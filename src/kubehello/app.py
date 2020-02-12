from fastapi import FastAPI
from starlette.responses import HTMLResponse

from kubehello.utils import find_hostname

app = FastAPI()


@app.get('/')
async def hello():
    current_host = find_hostname()
    return HTMLResponse(f"""
        <html>
          <head>
            <title>Kube system example</title>
          </head>
          <body>
            <h1>Hello world</h1>
            <p>Currently served from {current_host}</p>
          </body>
        </html>
        """)
