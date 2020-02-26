# Example Walkthrough

This dir contains some example files. The files have already bee downloaded from https://notebooks.geobigdata.io.

To build, push, register, and run the notebook, the following commands can be used:

```
docker build --file=Dockerfile --tag sparkgeo/notebook-test-run:latest --build-arg NOTEBOOK_NAME=notebook_manual_deploy.ipynb --build-arg TASK_SRC_DIR=examples/ .

docker login

docker push sparkgeo/notebook-test-run:latest

python register_notebook_task.py
```

At this point the task is on GBDX. Last thing to do is run a workflow:

```
from gbdxtools import Interface
gbdx = Interface()

task = gbdx.Task("MyNotebookTask", input_string="GBDX")
workflow = gbdx.Workflow([ task ])
workflow.execute()
```

It is best to run the above in an interactive session like Ipython or Jupyter, then the workflow can be monitored by running `worklfow.status`. Once the workflow is complete, the logs can be fetched by `workflow.stdout` or `workflow.stderr`.