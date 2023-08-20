#!/bin/bash

# Clean `dist`` folder
rm -rf dist

# Update `install_requires` section im setup.py
python scripts/update_install_requires.py

# Create a Source Distribution
python setup.py sdist

# Delete `egg_info` after build has completed
rm -r  pure_data.egg-info