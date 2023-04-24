# When to write tests
(https://ericmjl.github.io/essays-on-data-science/software-skills/testing/)
There are two "time scales" at which I think this question can be answered.

The first time scale is "short-term". As soon as we finish up a function, that first test should be written. Doing so lets us immediately sanity-check our intuition about the newly-written fuction.

The second time scale is "longer-term". As soon as we discover bugs, new tests should be added to the test suite. Those new tests should either cover that exact bug, or cover the class of bugs together.

A general rule-of-thumb that has proven reliable is to write an automated test for anything function you come to rely on.
