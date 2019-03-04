FROM python:2.7.15-alpine

ADD r3x-func.py /

RUN python -m pip install -i https://test.pypi.org/simple/ r3x 

ENV PORT=8080

CMD [ "python", "./r3x-func.py" ]