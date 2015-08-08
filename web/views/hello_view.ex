defmodule HelloPhoenix.HelloView do
  use HelloPhoenix.Web, :view

  def parse_query(query) do
    String.split(query, "\n", trim: true)
    |> Enum.map(&([min, hour, day, month, weekday, command] = String.split(&1, " ", parts: 6)))
    |> Enum.map(&(crontime_to_schedule(&1)))
  end

  defp crontime_to_schedule(crontime) do
    case crontime do
      [min, hour, day, month, _weekday, command] -> 
        case month do
         "*" -> ""
         month -> "#{month}月"
        end
        <>
        case [month, day] do
         ["*", "*"] -> ""
         [_, "*"] -> "の"
         ["*", day] -> "毎月#{day}日"
         [_, day] -> "#{day}日"
        end
        <>
        case [day, hour] do
         ["*", "*"] -> ""
         [_, "*"] -> "の"
         ["*", hour] -> "毎日#{hour}時"
         [_, hour] -> "#{hour}時"
        end
        <>
        case [hour, min] do
         [_, "*"] -> ""
         ["*", min] -> "毎時#{min}分"
         [_, min] -> "#{min}分"
        end
        <> "に#{command}"
    end
  end
end
