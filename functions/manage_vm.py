"""This script expects that the following environment vars are set:
AZURE_TENANT_ID: your Azure Active Directory tenant id or domain
AZURE_CLIENT_ID: your Azure Active Directory Application Client ID
AZURE_CLIENT_SECRET: your Azure Active Directory Application Secret
AZURE_SUBSCRIPTION_ID: your Azure Subscription Id
"""
import os
import traceback

from azure.common.credentials import ServicePrincipalCredentials
from azure.mgmt.resource import ResourceManagementClient
from azure.mgmt.compute import ComputeManagementClient
from azure.mgmt.compute.models import DiskCreateOption

from msrestazure.azure_exceptions import CloudError

VM_NAME = 'minecraft'
GROUP_NAME = "minecraft"

def get_credentials():
    subscription_id = os.environ['AZURE_SUBSCRIPTION_ID']
    credentials = ServicePrincipalCredentials(
        client_id=os.environ['AZURE_CLIENT_ID'],
        secret=os.environ['AZURE_CLIENT_SECRET'],
        tenant=os.environ['AZURE_TENANT_ID']
    )
    return credentials, subscription_id


def manage_action(operation):
    """Virtual Machine management example."""
    #
    # Create all clients with an Application (service principal) token provider
    #
    credentials, subscription_id = get_credentials()
    compute_client = ComputeManagementClient(credentials, subscription_id)


    try:
        if operation == "start":
            # Start the VM
            print('\nStart VM')
            async_vm_start = compute_client.virtual_machines.start(
                GROUP_NAME, VM_NAME)
            async_vm_start.wait()
        elif operation == "stop":
            # Stop the VM
            print('\nStop VM')
            async_vm_stop = compute_client.virtual_machines.power_off(
                GROUP_NAME, VM_NAME)
            async_vm_stop.wait()
        else:
            pass

    except CloudError:
        print('A VM operation failed:\n{}'.format(traceback.format_exc()))
    else:
        print('The operation completed successfully!')
    finally:
        print('\nBye.')
   