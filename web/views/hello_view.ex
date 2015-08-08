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
        case [month, day, hour] do
         ["*", "*", "*"] -> "毎時"
         ["*", "*", _] -> "毎日"
         ["*", _, _] -> "毎月"
         [_, _, _] -> "毎年"
        end
        <>
        case month do
         "*" -> ""
         month -> "#{month}月"
        end
        <>
        case [month, day] do
         ["*", "*"] -> ""
         [_, "*"] -> "の"
         [_, day] -> "#{day}日"
        end
        <>
        case [day, hour] do
         ["*", "*"] -> ""
         [_, "*"] -> "の"
         [_, hour] -> "#{hour}時"
        end
        <>
        case min do
         "*" -> ""
         min -> "#{min}分"
        end
        <> "に#{command}"
    end
  end
end
