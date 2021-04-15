import logging

import azure.functions as func
from .manage_vm import manage_action

def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    operation = req.params.get('operation')
    if not operation:
        try:
            req_body = req.get_json()
        except ValueError:
            pass
        else:
            operation = req_body.get('operation')

    if operation:
        manage_action(operation)
        return func.HttpResponse(f"Hello, {operation} performed. This HTTP triggered function executed successfully.")
    else:
        return func.HttpResponse(
             "This HTTP triggered function executed successfully. Pass an operation in the query string.",
             status_code=200
        )
