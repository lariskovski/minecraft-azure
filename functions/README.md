# Project Part 02: Python Azure Function

Simple how to for creating an Azure Function to manage your virtual machines. Like that Minecraft server you setup to play with a couple friends, there is no need for it to be up 24/7 and you also don't wanna go into the Azure Portal everytime to start/stio it or give your friends access on your subscription.

## 1. Creating The Function App on Azure Portal

### Azure App Registration

The following info will be used as env vars.

1. Client ID and Tenant ID: Create App registration (service account) on AD. Get it's Client ID and Tenant ID.

2. Client Secret: On the left panel, go to Manage > Certificates & Secrets > Client Secret > New client secret. 

4. Roles: Go to the recently created function's iam and set contributer role to the created App registration account (Function App > IAM > Role Assignments).

## 2. Developing the Azure Functions Locally on CLI

### Requirements

~~~~
sudo apt install nodejs npm python3 python3-pip -y
sudo npm install -g azure-functions-core-tools@3 --unsafe-perm true
~~~~

### Create The Default Function

Interactive

~~~~
func init   # Choose Python
func new    # Choose Http trigger (9)
~~~~

### Set Environment Variables

Set env vars with the infos gathered previously from the App register like below:

~~~~
export AZURE_TENANT_ID=
export AZURE_CLIENT_ID=
export AZURE_SUBSCRIPTION_ID=
export AZURE_CLIENT_SECRET=     # Value, not ID
~~~~

### Run the Default Function Locally

~~~~
pip install -r requirements.txt
func start # run created function locally
# test the default funct http://[ip]:7071/api/[func-name-on-azure]?name=larissa
~~~~

## Custom Function Code

Import your custom code in the ``__init__.py`` file genereted by the ``func new`` command.

~~~~
from .[modulename] import [function-name]
~~~~

[Import modules in Azure Functions](https://youtu.be/b2iSGT29CDk?t=1093)

> Dont forget to add the requirements to the fuctions root requirements.txt!

### Publish the Function 

Publish the code to the created function app on azure.

~~~~
func azure functionapp publish [func-name-on-azure]
~~~~

> Dont forget to add the env variables to the Function App settings.

~~~~
AZURE_TENANT_ID=
AZURE_CLIENT_ID=
AZURE_SUBSCRIPTION_ID=
AZURE_CLIENT_SECRET= # Value, not ID
~~~~

## Sources
[Python script template](https://github.com/Azure-Samples/virtual-machines-python-manage)