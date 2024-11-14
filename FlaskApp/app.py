from flask import Flask, render_template, request, redirect, url_for, flash
import yaml
import subprocess
import os

app = Flask(__name__)
app.secret_key = 'supersecretkey'  # Nodig voor flash-meldingen

@app.route('/', methods=['GET', 'POST'])
def onboarding_form():
    if request.method == 'POST':
        given_name = request.form['given_name']
        middle_name = request.form['middle_name']
        last_name = request.form['last_name']
        birth_date = request.form['birth_date']
        department = request.form['department']

        # Maak een dictionary voor de variabelen
        variables = {
            'given_name': given_name,
            'middle_name': middle_name,
            'last_name': last_name,
            'birth_date': birth_date,
            'department': department
        }

        # Sla de variabelen op in een bestand (bijv. vars.yml)
        with open('vars.yml', 'w') as file:
            yaml.dump(variables, file)

        # Voer het Ansible-playbook uit
        try:
            result = subprocess.run(
                ['ansible-playbook', '-i', 'inventory.ini', 'onboarding_playbook.yml', '-e', '@vars.yml'],
                check=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True
            )
            flash("Het Ansible playbook is succesvol uitgevoerd!", "success")
            print(result.stdout)  # Print de standaarduitvoer van het playbook
        except subprocess.CalledProcessError as e:
            flash(f"Er is een fout opgetreden bij het uitvoeren van het Ansible playbook: {e.stderr}", "danger")
            print(e.stderr)  # Print de foutuitvoer voor debugging


        return redirect(url_for('onboarding_form'))

    return render_template('form.html')


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)