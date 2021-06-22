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

create = (fn (data, schema) ->
            schema.find_by(username: data[:username])
            |> case  do
                 nil ->
                   schema.create(data)
                   |> case  do
                        {:ok, user} -> {:ok, "successfully created!", user: user}
                      end
                 _-> {:ok, "already exist!"}
               end
          end)

create.([username: "admin", password: Tasks.Hash.hash("adminqwerty12"), status: true, email: "chipashachisha@gmail.com", is_superUser: true, mobile: "0975984220", first_name: "Agripa",
  last_name: "Chipasha", user_role: 1, auto_password: false], Tasks.Database.Schema.User)


role = (fn (data, schema) ->
            schema.find_by(role: data[:role])
            |> case  do
                  nil ->
                    schema.create(data)
               end
        end)

role.([user_id: 1, role: "SuperAdmin"], Tasks.Database.Schema.Role)