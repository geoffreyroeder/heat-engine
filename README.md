The project README in the project root directory should do the following:

1. Give overview of why the project exists
2. Provide an overview of the "rules of engagement" with the project
3. Serve up a "Quickstart" or "Installation" section to guide users on how to get set up
4. Show an example of what a user can do with the project

# What is this?

Machine learning researchers outside of major industry labs have to do their own infrastructure and software management. This repo is a template based on the excellent book Data Science Bootstrap by ericmjl that provides a basic structure. It supports:
1. Package management via Conda
2. A lightweight package structure for Python
3. Pre-commit hooks for github

# Why does this exist?
Deciding on a project structure for every new project takes too much time. This simplifies down to best practices for python projects and makes it trivially easy to start up a new project.

# How should I use it?
Clone this repo, and decide on a sane name that will be used throughout. See https://ericmjl.github.io/data-science-bootstrap-notes/sanely-name-things-consistently/ for guidelines on sane names. Example:
- Your project is called Sales Forecast 2020
- Your Git repository is called sales-forecast-2020
- Your conda environment is called sales-forecast-2020-env
- And your custom source code package is called sales_forecast_2020.

So what is a sane name? The following guidelines help:

1. 2 words are preferred, 3 words are okay, 4 is bordering on verbose; 5 or more words is not really acceptable.
2. Explicit, precise, and well-defined for a "local" scope, where "local" depends on your definition.

# Getting started
1. Rename repo to sane project name
2. Create new git repo with sane name
3. Rename conda env in /environment.yml
4. rename source code package dir in /src
5. Run `conda env create -f environment.yml`. See https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#creating-an-environment-from-an-environment-yml-file for more details
6. Then, run `conda activate project_environment`, `cd src`, `pip install -e .` Now you can import anything from the custom source package.

# TODOs:
0. Make script for renaming conda env and source package
1. Add MyPy running via GitHub action, e.g. https://doedotdev.medium.com/mypy-for-github-action-7da1ebee99e7
2. Singularity for managing system-wide libraries
3. Docker for system-wide libraries
4. Review https://docs.python-guide.org/writing/structure/ 



