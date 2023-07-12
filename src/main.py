import time
from fastapi import FastAPI, Request
from typing import Union

app = FastAPI()


@app.get("/")
def root():
    return {
        """This is a Data Product API based on open crypto API's for education purpose. 
        There is no financial advice given with this API
        """
    }
