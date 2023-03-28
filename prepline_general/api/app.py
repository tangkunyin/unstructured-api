#####################################################################
# THIS FILE IS AUTOMATICALLY GENERATED BY UNSTRUCTURED API TOOLS.
# DO NOT MODIFY DIRECTLY
#####################################################################


from fastapi import FastAPI, Request, status

from .general import router as general_router


app = FastAPI(
    title="Unstructured Pipeline API",
    description="""""",
    version="1.0.0",
    docs_url="/general/docs",
)

app.include_router(general_router)


@app.get("/healthcheck", status_code=status.HTTP_200_OK)
def healthcheck(request: Request):
    return {"healthcheck": "HEALTHCHECK STATUS: EVERYTHING OK!"}
