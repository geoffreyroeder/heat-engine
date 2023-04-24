from dotenv import load_dotenv
from pyprojroot import here
import os

dotenv_path = here() / ".env"
load_dotenv(dotenv_path=dotenv_path)  # loads .env file in project directory root.


from custom_lib import another_function

def test_another_function():
    arg1 = ...
    arg2 = ...
    result = another_function(arg1, arg2)

    expected_result = ...

    assert result == expected_result
