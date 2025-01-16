import subprocess
import logging
import yaml
import os
from flask import Flask, render_template, request, redirect, url_for, flash

app = Flask(__name__)
app.secret_key = 'supersecretkey'

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@app.route('/', methods=['GET', 'POST'])
def onboarding_form():
    if request.method == 'POST':
        # Onboarding logic
        given_name = request.form['given_name']
        middle_name = request.form.get('middle_name', '')
        last_name = request.form['last_name']
        birth_date = request.form['birth_date']
        department = request.form['department']

        # Validate department
        if department not in ['IT department', 'HR department']:
            flash("Invalid department selected. Choose IT or HR.", "danger")
            return redirect(url_for('onboarding_form'))

        # Save variables to YAML
        variables = {
            'given_name': given_name,
            'middle_name': middle_name,
            'last_name': last_name,
            'birth_date': birth_date,
            'department': department
        }

        with open('vars.yml', 'w') as file:
            yaml.dump(variables, file)

        # Run Onboarding Playbook
        try:
            result = subprocess.Popen(
                ['ansible-playbook', '-i', 'inventory.ini', 'onboarding_playbook.yml', '-e', '@vars.yml', '-vvvv'],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True
            )

            for line in iter(result.stdout.readline, ''):
                logger.info(line.strip())
                print(line.strip())

            result.stdout.close()
            result.wait()

            if result.returncode == 0:
                flash("Onboarding playbook executed successfully!", "success")
            else:
                flash(f"Onboarding playbook failed with code {result.returncode}. Check logs for details.", "danger")

        except Exception as e:
            logger.error(f"Error executing playbook: {e}")
            flash(f"An error occurred: {e}", "danger")

        return redirect(url_for('onboarding_form'))

    return render_template('form.html', form_type="onboarding")


@app.route('/offboarding', methods=['GET', 'POST'])
def offboarding_form():
    if request.method == 'POST':
        # Offboarding logic
        employee_name = request.form['given_name']  # Reuse the 'given_name' field for username
        department = request.form['department']

        # Save variables to YAML
        variables = {
            'employee_name': employee_name,
            'department': department
        }

        with open('offboarding_vars.yml', 'w') as file:
            yaml.dump(variables, file)

        # Run Offboarding Playbook
        try:
            result = subprocess.Popen(
                ['ansible-playbook', '-i', 'inventory.ini', 'offboarding_playbook.yml', '-e', '@offboarding_vars.yml', '-vvvv'],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True
            )

            for line in iter(result.stdout.readline, ''):
                logger.info(line.strip())
                print(line.strip())

            result.stdout.close()
            result.wait()

            if result.returncode == 0:
                flash("Offboarding playbook executed successfully!", "success")
            else:
                flash(f"Offboarding playbook failed with code {result.returncode}. Check logs for details.", "danger")

        except Exception as e:
            logger.error(f"Error executing playbook: {e}")
            flash(f"An error occurred: {e}", "danger")

        return redirect(url_for('offboarding_form'))

    return render_template('form.html', form_type="offboarding")


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
