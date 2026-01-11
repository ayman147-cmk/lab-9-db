import click
from db_manager import get_db_connection

class UniversityInterface:
    def __init__(self):
        self.provider = get_db_connection

    def run_query(self, sql, params=None, is_select=False):
        conn = self.provider()
        ptr = conn.cursor()
        try:
            ptr.execute(sql, params or ())
            if is_select:
                return ptr.fetchall()
            conn.commit()
            return True
        except Exception as e:
            raise e
        finally:
            conn.close()

ui_logic = UniversityInterface()

@click.group()
def main_portal():
    pass

@main_portal.command(name="new-course")
@click.argument("name")
def insert_subject(name):
    try:
        stmt = "INSERT INTO COURS (titre, credits) VALUES (%s, %s)"
        ui_logic.run_query(stmt, (name, 3))
        click.secho(f"Success: Subject '{name}' created.", fg="cyan")
    except Exception as error:
        click.secho(f"Failure: {error}", fg="yellow")

@main_portal.command(name="show-all")
def display_catalog():
    try:
        data = ui_logic.run_query("SELECT * FROM COURS", is_select=True)
        if not data:
            click.echo("Status: No records found.")
            return
        
        click.echo("=== UNIVERSITY CATALOG ===")
        for row in data:
            click.echo(f"Ref: {row[0]} >> {row[1]} ({row[2]} pts)")
    except Exception as error:
        click.echo(f"Internal Error: {error}")

@main_portal.command(name="remove-id")
@click.argument("ref_id", type=int)
def drop_entry(ref_id):
    try:
        ui_logic.run_query("DELETE FROM COURS WHERE id = %s", (ref_id,))
        click.echo(f"Action: Entry {ref_id} wiped.")
    except Exception as error:
        click.echo(f"Denied: {error}")

if __name__ == "__main__":
    main_portal()