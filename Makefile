venv_name = <venv_name>

venv:
	python -m venv ~/.venv/$(venv_name)
	source ~/.venv/$(venv_name)/bin/activate

venv_jupyter:
	python -m ipykernel install --user --name venv_name --display-name "$(venv_name)"
	
install:
	pip install --upgrade pip &&\
		pip install -r requirements.txt
test:
	python -m pytest -vv --cov=main --cov=mylib test_*.py

format:	
	black *.py

lint:
	pylint --disable=R,C --ignore-patterns=test_.*?py *.py mylib/*.py\
		 hugging-face/zero_shot_classification.py hugging-face/hf_whisper.py

container-lint:
	docker run --rm -i hadolint/hadolint < Dockerfile

checkgpu:
	echo "Checking GPU for PyTorch"
	python utils/verify_pytorch.py
	echo "Checking GPU for Tensorflow"
	python utils/verify_tf.py

refactor: format lint

deploy:
	#deploy goes here
		
all: venv install lint test format deploy
