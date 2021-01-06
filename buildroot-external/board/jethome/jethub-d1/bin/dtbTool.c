/*
 * Copyright (c) 2012, Code Aurora Forum. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
       * Redistributions of source code must retain the above copyright
         notice, this list of conditions and the following disclaimer.
       * Redistributions in binary form must reproduce the above
         copyright notice, this list of conditions and the following
         disclaimer in the documentation and/or other materials provided
         with the distribution.
       * Neither the name of Code Aurora Forum, Inc. nor the names of its
         contributors may be used to endorse or promote products derived
         from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
 * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#define _GNU_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <getopt.h>
#include <errno.h>
#include <unistd.h>

#define AML_DT_MAGIC     "AML_"  /* Master DTB magic */
#define AML_DT_VERSION   2       /* AML version */

#define DT_ID_TAG    "amlogic-dt-id"

#define PAGE_SIZE_DEF  2048
#define PAGE_SIZE_MAX  (1024*1024)

#define log_err(x...)  printf(x)
#define log_info(x...) printf(x)
#define log_dbg(x...)  { if (verbose) printf(x); }

#define COPY_BLK       1024    /* File copy block size */

#define RC_SUCCESS     0
#define RC_ERROR       -1

#define INFO_ENTRY_SIZE     16
#define INFO_ENTRY_SIZE_S  "16"
#define TABLE_ENTRY_HEADER_SIZE (INFO_ENTRY_SIZE * 3 + sizeof(uint32_t) * 2)

struct chipInfo_t {
  uint8_t chipset[INFO_ENTRY_SIZE];
  uint8_t platform[INFO_ENTRY_SIZE];
  uint8_t revNum[INFO_ENTRY_SIZE];
  uint32_t dtb_size;
  char     *dtb_file;
  struct chipInfo_t *prev;
  struct chipInfo_t *next;
};

struct chipInfo_t *chip_list;

char *input_dir;
char *output_file;
char *dtc_path;
int   verbose;
int   page_size = PAGE_SIZE_DEF;

int entry_cmp(uint8_t *a, uint8_t *b)
{
    return memcmp(a, b, INFO_ENTRY_SIZE);
}

uint32_t swap_bytes_u32(uint32_t b)
{
    return ((b & 0xFF000000) >> 24) |
           ((b & 0x00FF0000) >> 8) |
           ((b & 0x0000FF00) << 8) |
           (b << 24);
}
void padSpaces(uint8_t *s, int sz)
{
    --sz;
    while ( sz >= 0 && s[sz] == 0 )
    {
        s[sz] = 0x20;
        --sz;
    }
}

void print_help()
{
    log_info("dtbTool [options] -o <output file> <input DTB path>\n");
    log_info("  options:\n");
    log_info("  --output-file/-o     output file\n");
    log_info("  --dtc-path/-p        path to dtc\n");
    log_info("  --page-size/-s       page size in bytes\n");
    log_info("  --verbose/-v         verbose\n");
    log_info("  --help/-h            this help screen\n");
}

int parse_commandline(int argc, char *const argv[])
{
    int c;

    struct option long_options[] = {
        {"output-file", 1, 0, 'o'},
        {"dtc-path",    1, 0, 'p'},
        {"page-size",   1, 0, 's'},
        {"verbose",     0, 0, 'v'},
        {"help",        0, 0, 'h'},
        {0, 0, 0, 0}
    };

    while ((c = getopt_long(argc, argv, "-o:p:s:vh", long_options, NULL))
           != -1) {
        switch (c) {
        case 1:
            if (!input_dir) {
                input_dir = optarg;
                {
                    int len = strlen(input_dir);
                    if ( len > 1 && input_dir[len - 1] != '/' ) {
                        input_dir = malloc(len + 2);
                        strcpy(input_dir, optarg);
                        input_dir[len] = '/';
                        input_dir[len + 1] = 0;
                    }
                }
            }
            break;
        case 'o':
            output_file = optarg;
            break;
        case 'p':
            dtc_path = optarg;
            break;
        case 's':
            page_size = atoi(optarg);
            if ((page_size <= 0) || (page_size > (PAGE_SIZE_MAX))) {
                log_err("Invalid page size (> 0 and <=1MB\n");
                return RC_ERROR;
            }
            break;
        case 'v':
            verbose = 1;
            break;
        case 'h':
        default:
            return RC_ERROR;
        }
    }

    if (!output_file) {
        log_err("Output file must be specified\n");
        return RC_ERROR;
    }

    if (!input_dir)
        input_dir = "./";

    if (!dtc_path)
        dtc_path = "";

    return RC_SUCCESS;
}

/* Unique entry sorted list add (by chipset->platform->rev) */
int chip_add(struct chipInfo_t *c)
{
    struct chipInfo_t *x = chip_list;

    if (!chip_list) {
        chip_list = c;
        c->next = NULL;
        c->prev = NULL;
        return RC_SUCCESS;
    }

    while (1) {
        if (entry_cmp(c->chipset, x->chipset) < 0 ||
            (entry_cmp(c->chipset, x->chipset) == 0 &&
             (entry_cmp(c->platform, x->platform) < 0 ||
              (entry_cmp(c->platform, x->platform) == 0 &&
               entry_cmp(c->revNum, x->revNum) < 0)))) {
            if (!x->prev) {
                c->next = chip_list;
                c->prev = NULL;
                chip_list = c;
                break;
            } else {
                c->next = x;
                c->prev = x->prev;
                x->prev->next = c;
                x->prev = c;
                break;
            }
        }
        if (entry_cmp(c->chipset, x->chipset) == 0 &&
            entry_cmp(c->platform, x->platform) == 0 &&
            entry_cmp(c->revNum, x->revNum) == 0) {
            return RC_ERROR;  /* duplicate */
        }
        if (!x->next) {
            c->prev = x;
            c->next = NULL;
            x->next = c;
            break;
        }
        x = x->next;
    }
    return RC_SUCCESS;
}

void chip_deleteall()
{
    struct chipInfo_t *c = chip_list, *t;

    while (c) {
        t = c;
        c = c->next;
        free(t->dtb_file);
        free(t);
    }
}

/* Extract 'qcom,msm-id' parameter triplet from DTB
      qcom,msm-id = <x y z>;
 */
struct chipInfo_t *getChipInfo(const char *filename)
{
    const char str1[] = "dtc -I dtb -O dts \"";
    const char str2[] = "\" 2>&1";
    char *buf, *pos;
    char *line = NULL;
    size_t line_size;
    FILE *pfile;
    int llen;
    struct chipInfo_t *chip = NULL;
    int rc = 0;
    uint8_t data[3][INFO_ENTRY_SIZE + 1] = { {0} };

    line_size = 1024;
    line = (char *)malloc(line_size);
    if (!line) {
        log_err("Out of memory\n");
        return NULL;
    }

    llen = sizeof(char) * (strlen(dtc_path) +
                           strlen(str1) +
                           strlen(str2) +
                           strlen(filename) + 1);
    buf = (char *)malloc(llen);
    if (!buf) {
        log_err("Out of memory\n");
        free(line);
        return NULL;
    }

    strncpy(buf, dtc_path, llen);
    strncat(buf, str1, llen);
    strncat(buf, filename, llen);
    strncat(buf, str2, llen);

    pfile = popen(buf, "r");
    free(buf);

    if (pfile == NULL) {
        log_err("... skip, fail to decompile dtb\n");
    } else {
        /* Find "dtb file entry" */
        while ((llen = getline(&line, &line_size, pfile)) != -1) {
            if ((pos = strstr(line, DT_ID_TAG)) != NULL) {
                pos += strlen(DT_ID_TAG);

                for (; *pos; pos++) {
                    if (*pos == '"') {
                        /* Start convertion of triplet */
                        pos++;
                        rc = sscanf(pos, "%" INFO_ENTRY_SIZE_S "[^_]_%" INFO_ENTRY_SIZE_S "[^_]_%" INFO_ENTRY_SIZE_S "[^_\"]\"",
                                    data[0], data[1], data[2]);
                        if (rc == 3) {
                            chip = (struct chipInfo_t *)
                                       malloc(sizeof(struct chipInfo_t));
                            if (!chip) {
                                log_err("Out of memory\n");
                                break;
                            }
                            memcpy(chip->chipset, data[0], INFO_ENTRY_SIZE);
                            memcpy(chip->platform, data[1], INFO_ENTRY_SIZE);
                            memcpy(chip->revNum, data[2], INFO_ENTRY_SIZE);
                            chip->dtb_size = 0;
                            chip->dtb_file = NULL;

                            free(line);
                            pclose(pfile);
                            return chip;
                        } else {
                            break;
                        }
                    }
                }
                log_err("... skip, incorrect '%s' format\n", DT_ID_TAG);
                break;
            }
        }
        if (line)
            free(line);
        pclose(pfile);
    }

    return NULL;
}

int main(int argc, char **argv)
{
    char buf[COPY_BLK];
    struct chipInfo_t *chip;
    struct dirent *dp;
    FILE *pInputFile;
    char *filename;
    int padding;
    uint8_t *filler = NULL;
    int numBytesRead = 0;
    int totBytesRead = 0;
    int out_fd;
    int flen;
    int rc = RC_SUCCESS;
    int dtb_count = 0, dtb_offset = 0;
    size_t wrote = 0, expected = 0;
    struct stat st;
    uint32_t version = AML_DT_VERSION;

    log_info("DTB combiner:\n");

    if (parse_commandline(argc, argv) != RC_SUCCESS) {
        print_help();
        return RC_ERROR;
    }

    log_info("  Input directory: '%s'\n", input_dir);
    log_info("  Output file: '%s'\n", output_file);

    DIR *dir = opendir(input_dir);
    if (!dir) {
        log_err("Failed to open input directory '%s'\n", input_dir);
        return RC_ERROR;
    }

    filler = (uint8_t *)malloc(page_size);
    if (!filler) {
        log_err("Out of memory\n");
        closedir(dir);
        return RC_ERROR;
    }
    memset(filler, 0, page_size);

    /* Open the .dtb files in the specified path, decompile and
       extract "amlogic-dt-id" parameter
     */
    while ((dp = readdir(dir)) != NULL) {
        if ((dp->d_type == DT_REG)) {
            flen = strlen(dp->d_name);
            if ((flen > 4) &&
                (strncmp(&dp->d_name[flen-4], ".dtb", 4) == 0)) {
                log_info("Found file: %s ... ", dp->d_name);

                flen = strlen(input_dir) + strlen(dp->d_name) + 1;
                filename = (char *)malloc(flen);
                if (!filename) {
                    log_err("Out of memory\n");
                    rc = RC_ERROR;
                    break;
                }
                strncpy(filename, input_dir, flen);
                strncat(filename, dp->d_name, flen);

                chip = getChipInfo(filename);
                if (!chip) {
                    log_err("skip, failed to scan for '%s' tag\n",
                            DT_ID_TAG);
                    free(filename);
                    continue;
                }

                if ((stat(filename, &st) != 0) ||
                    (st.st_size == 0)) {
                    log_err("skip, failed to get DTB size\n");
                    free(filename);
                    continue;
                }

                log_info("chipset: %" INFO_ENTRY_SIZE_S "s, "
                         "platform: %" INFO_ENTRY_SIZE_S "s, "
                         "rev: %" INFO_ENTRY_SIZE_S "s\n",
                         chip->chipset, chip->platform, chip->revNum);

                rc = chip_add(chip);
                if (rc != RC_SUCCESS) {
                    log_err("... duplicate info, skipped\n");
                    free(filename);
                    continue;
                }

                dtb_count++;

                chip->dtb_size = st.st_size +
                                   (page_size - (st.st_size % page_size));
                chip->dtb_file = filename;
            }
        }
    }
    closedir(dir);
    log_info("=> Found %d unique DTB(s)\n", dtb_count);

    if (!dtb_count)
        goto cleanup;


    /* Generate the master DTB file:

       Simplify write error handling by just checking for actual vs
       expected bytes written at the end.
     */

    log_info("\nGenerating master DTB... ");

    out_fd = open(output_file, O_WRONLY|O_CREAT|O_TRUNC, S_IRUSR|S_IWUSR);
    if (!out_fd < 0) {
        log_err("Cannot create '%s'\n", output_file);
        rc = RC_ERROR;
        goto cleanup;
    }

    /* Write header info */
    wrote += write(out_fd, AML_DT_MAGIC, sizeof(uint8_t) * 4); /* magic */
    wrote += write(out_fd, &version, sizeof(uint32_t));      /* version */
    wrote += write(out_fd, (uint32_t *)&dtb_count, sizeof(uint32_t));
                                                             /* #DTB */

    /* Calculate offset of first DTB block */
    dtb_offset = 12               + /* header */
                 (TABLE_ENTRY_HEADER_SIZE * dtb_count) + /* DTB table entries */
                 4;                 /* end of table indicator */
    /* Round up to page size */
    padding = page_size - (dtb_offset % page_size);
    dtb_offset += padding;
    expected = dtb_offset;

    /* Write index table:
         chipset
         platform
         soc rev
         dtb offset
         dtb size
     */
    for (chip = chip_list; chip; chip = chip->next) {
        /* for some reason, the id entries are padded with spaces (0x20)
        and are flipped. */
        {
            int i;
            uint32_t *u32chipset = (uint32_t*)chip->chipset,
                     *u32platform = (uint32_t*)chip->platform,
                     *u32revNum = (uint32_t*)chip->revNum;

            padSpaces(chip->chipset, INFO_ENTRY_SIZE);
            padSpaces(chip->platform, INFO_ENTRY_SIZE);
            padSpaces(chip->revNum, INFO_ENTRY_SIZE);
            for ( i = 0; i < INFO_ENTRY_SIZE/sizeof(uint32_t); ++i ) {
                *(u32chipset + i) = swap_bytes_u32(*(u32chipset + i));
                *(u32platform + i) = swap_bytes_u32(*(u32platform + i));
                *(u32revNum + i) = swap_bytes_u32(*(u32revNum + i));
            }
        }
        wrote += write(out_fd, chip->chipset, INFO_ENTRY_SIZE);
        wrote += write(out_fd, chip->platform, INFO_ENTRY_SIZE);
        wrote += write(out_fd, chip->revNum, INFO_ENTRY_SIZE);
        wrote += write(out_fd, &expected, sizeof(uint32_t));
        wrote += write(out_fd, &chip->dtb_size, sizeof(uint32_t));
        expected += chip->dtb_size;
    }

    rc = RC_SUCCESS;
    wrote += write(out_fd, &rc, sizeof(uint32_t)); /* end of table indicator */
    if (padding > 0)
        wrote += write(out_fd, filler, padding);

    /* Write DTB's */
    for (chip = chip_list; chip; chip = chip->next) {
        log_dbg("\n (writing '%s' - %u bytes) ", chip->dtb_file, chip->dtb_size);
        pInputFile = fopen(chip->dtb_file, "r");
        if (pInputFile != NULL) {
            totBytesRead = 0;
            while ((numBytesRead = fread(buf, 1, COPY_BLK, pInputFile)) > 0) {
                wrote += write(out_fd, buf, numBytesRead);
                totBytesRead += numBytesRead;
            }
            fclose(pInputFile);
            padding = page_size - (totBytesRead % page_size);
            if ((uint32_t)(totBytesRead + padding) != chip->dtb_size) {
                log_err("DTB size mismatch, please re-run: expected %d vs actual %d (%s)\n",
                        chip->dtb_size, totBytesRead + padding,
                        chip->dtb_file);
                rc = RC_ERROR;
                break;
            }
            if (padding > 0)
                wrote += write(out_fd, filler, padding);
        } else {
            log_err("failed to open DTB '%s'\n", chip->dtb_file);
            rc = RC_ERROR;
            break;
        }
    }
    close(out_fd);

    if (expected != wrote) {
        log_err("error writing output file, please rerun: size mismatch %d vs %d\n",
                expected, wrote);
        rc = RC_ERROR;
    } else
        log_dbg("Total wrote %u bytes\n", wrote);

    if (rc != RC_SUCCESS)
        unlink(output_file);
    else
        log_info("completed\n");

cleanup:
    free(filler);
    chip_deleteall();
    return rc;
}