# If you find that your project's environment Python is unavailable, then you'll need to ensure that it's available. To do so, ensure that the Python environment has the package ipykernel. (If not, install it by hand and add it to the environment.yml file.) Then, run the following command:

# assuming you have already activated your environment,
# replace $ENVIRONMENT_NAME with your environment's name.
python -m ipykernel install --user --name $ENVIRONMENT_NAME
