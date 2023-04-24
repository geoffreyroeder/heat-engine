"""
This module houses all functions that cannot be neatly categorized
in other places.
"""

from dotenv import load_dotenv
from pyprojroot import here
import os

dotenv_path = here() / ".env"
load_dotenv(dotenv_path=dotenv_path)  # loads .env file in project directory root.

# Example: get the environment variable
# DATABASE_CONNECTION_STRING = os.getenv("DATABASE_CONNECTION_STRING")

def my_function(arg1, arg2):
    """
    Calculates something based on arg1 and arg2.

    This calculated thing is intended to be used
    by `this_other_function`,
    so the return type should not be changed.

    :param arg1: Describe arg1
    :param arg2: Describe arg2
    :returns: ``the_thing_being_returned``, a pandas DataFrame (for example).
    """
    the_thing_being_returned = ...  # implement the function
    return the_thing_being_returned
