FROM sparkgeo/notebooks-manual-task:current

ARG TASK_CONDA_ENV=gbdx_py3
ARG TASK_EXEC_PATH=/anaconda/envs/${TASK_CONDA_ENV}/bin
ARG TASK_DEST_DIR=/home/gremlin
ARG TASK_SRC_DIR="."
ARG NOTEBOOK_NAME

ADD ${TASK_SRC_DIR} ${TASK_DEST_DIR}

RUN /anaconda/bin/conda env update -n ${TASK_CONDA_ENV} --file ${TASK_DEST_DIR}/requirements.yml

RUN /anaconda/envs/${TASK_CONDA_ENV}/bin/pip install rio_hist

RUN /anaconda/bin/conda clean -tipsy && \
    /anaconda/bin/conda clean -y --all && \
    /anaconda/bin/conda build purge-all 

RUN mkdir -p /mnt/work/output/task_output

CMD ["${TASK_EXEC_PATH}/jupyter", "nbconvert", "--ExecutePreprocessor.timeout=60000", "--to" "notebook", "--execute", "${TASK_DEST_DIR}/${NOTEBOOK_NAME}", "--output", "/mnt/work/output/task_output/output.ipynb", "--log-level", "DEBUG"]