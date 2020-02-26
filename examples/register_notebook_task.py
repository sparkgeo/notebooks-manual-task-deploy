from gbdxtools import TaskRegistry

TASK_NAME = "MyNotebookTask"
TASK_DICT = {
      "name": TASK_NAME,
      "version": "0.0.1",
      "description": "Test notebook task",
      "taskOwnerEmail": "mike.connor@digitalglobe.com",
      "properties": {
        "isPublic": False,
        "authorizationRequired": True
      },
      "inputPortDescriptors": [
          {
              "name": "input_string",
              "type": "string",
              "required": True
          }
      ],
      "outputPortDescriptors": [],
      "containerDescriptors": [
        {
          "type": "DOCKER"
          "properties": {"image": "michaelconnor00/notebook-test-run:latest"}
        }
      ]
}

tr = TaskRegistry()

print(tr.register(task_json=TASK_DICT))

print(tr.get_definition(TASK_NAME))
