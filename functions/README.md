## Azure Permissions

Create register app account on subscription page

Go to the recently created function's iam and set contributer role to the created registered app.

Set env vars with the infos (client id, secret etc)

~~~~
export AZURE_TENANT_ID=
export AZURE_CLIENT_ID=
export AZURE_SUBSCRIPTION_ID=
export AZURE_CLIENT_SECRET= # Value, not ID
~~~~

## Developing and Testing Azure Functions Locally

### Requirements

~~~~
sudo apt install nodejs npm python3 python3-pip -y
sudo npm install -g azure-functions-core-tools@3 --unsafe-perm true
~~~~

### Create The Default Function Interactive

~~~~
func init
func new
func start # run created function locally
# test the default funct http://[ip]:7071/api/[func-name-on-azure]?name=larissa
func azure functionapp publish [func-name-on-azure]
~~~~

### Run Function Locally

pip install -r requirements.txt
python3 func.py

## Custom Function

Import your custom created function in the ``__init__.py`` file created by the func command.

~~~~
from .modulename import [function-name]
~~~~

[Import modules in Azure Functions](https://youtu.be/b2iSGT29CDk?t=1093)

> Dont forget to add the requirements to the fuctions root requirements.txt!

### Public the Function 

Publish the code to the created function on azure.

> Dont forget to add the env variables to the Function App config.

~~~~
AZURE_TENANT_ID=
AZURE_CLIENT_ID=
AZURE_SUBSCRIPTION_ID=
AZURE_CLIENT_SECRET= # Value, not ID
~~~~

## Sources
[Python script template](https://github.com/Azure-Samples/virtual-machines-python-manage)