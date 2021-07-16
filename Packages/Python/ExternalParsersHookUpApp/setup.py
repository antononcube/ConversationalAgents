import setuptools

with open("README.md", "r") as fh:
    long_description = fh.read()

setuptools.setup(
    name="ExternalParsersHookUp-antononcube",
    version="0.0.5",
    author="Anton Antonov",
    author_email="antononcube@posteo.net",
    description="External Raku parsers hook-up package",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/antononcube/ConversationalAgents",
    packages=setuptools.find_packages(),
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: BSD-3",
        "Operating System :: OS Independent",
    ],
    python_requires='>=3.6',
)