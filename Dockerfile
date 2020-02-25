FROM sparkgeo/notebooks-manual-task:latest

ENV TASK_CONDA_ENV=gbdx_py3
ENV TASK_EXEC_PATH=/anaconda/envs/${TASK_CONDA_ENV}/bin
ENV TASK_PATH=/home/gremlin
ARG NOTEBOOK_NAME

ADD . ${TASK_PATH}

RUN /anaconda/bin/conda env update -n ${TASK_CONDA_ENV} -c conda-forge -c digitalglobe update --file ${TASK_PATH}/requirements.yml

RUN mkdir -p /mnt/work/output/task_output

CMD ["${TASK_EXEC_PATH}/jupyter", "nbconvert", "--ExecutePreprocessor.timeout=60000", "--to" "notebook", "--execute", "${TASK_PATH}/${NOTEBOOK_NAME}", "--output", "/mnt/work/output/task_output/output.ipynb", "--log-level", "DEBUG"]