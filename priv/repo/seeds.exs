# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Tasks.Repo.insert!(%Tasks.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Tasks.Database.Schema.User
alias Tasks.Database.Schema.Role
alias Tasks.Database.Table.Login

multiple_run = (fn schema, find, entries ->
  schema.find_by(find)
  |> case do
       nil -> schema.create(Enum.concat(find, entries))
       data -> {:update, data}
     end
 end)

multiple_run.(User, [username: "admin"], [username: "admin", password: Tasks.Hash.hash("adminqwerty12"), status: true, email: "chipashachisha@gmail.com", is_superUser: true, mobile: "0975984220", first_name: "Agripa",
                    last_name: "Chipasha", user_role: 1, auto_password: false])
multiple_run.(Role, [role: "SuperAdmin"], [user_id: 1, role: "SuperAdmin"])
multiple_run.(Login, [attempts: 5], [attempts: 5, updated_by: 1, date_updated: Timex.now() |> Timex.to_date()])