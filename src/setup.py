import setuptools

with open("README.md", "r", encoding="utf-8") as fh:
    long_description = fh.read()

setuptools.setup(
    name="nilss", # Replace with your environment name
    version="0.1",         # Replace with anything that you need
    packages=setuptools.find_packages(),
)
