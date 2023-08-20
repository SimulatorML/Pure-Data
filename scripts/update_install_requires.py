def get_requirements():
    """
    Converts the data from the requirements.txt file into a list of modules
    """
    with open("requirements.txt", "r", encoding="utf-8") as req_file:
        return [line.strip() for line in req_file if line.strip()]

if __name__ == "__main__":
    requirements = get_requirements()

    with open("scripts/setup_template.py", "r", encoding="utf-8") as setup_file:
        setup_script = setup_file.read()

    updated_script = setup_script.replace(
        "install_requires=[]",
        f"install_requires={requirements}",
    )

    with open("setup.py", "w", encoding="utf-8") as setup_file:
        setup_file.write(updated_script)
