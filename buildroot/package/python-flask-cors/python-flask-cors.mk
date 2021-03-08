################################################################################
#
# python-flask-cors
#
################################################################################

PYTHON_FLASK_CORS_VERSION = 3.0.10
PYTHON_FLASK_CORS_SOURCE = Flask-Cors-$(PYTHON_FLASK_CORS_VERSION).tar.gz
PYTHON_FLASK_CORS_SITE = https://files.pythonhosted.org/packages/cf/25/e3b2553d22ed542be807739556c69621ad2ab276ae8d5d2560f4ed20f652
PYTHON_FLASK_CORS_SETUP_TYPE = setuptools
PYTHON_FLASK_CORS_LICENSE = MIT
PYTHON_FLASK_CORS_LICENSE_FILES = LICENSE
PYTHON_FLASK_CORS_CPE_ID_VENDOR = flask-cors_project
PYTHON_FLASK_CORS_CPE_ID_PRODUCT = flask-cors

$(eval $(python-package))
