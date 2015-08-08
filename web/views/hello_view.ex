defmodule HelloPhoenix.HelloView do
  use HelloPhoenix.Web, :view

  def parse_query(query) do
    String.split(query, ",", trim: true)
    |> Enum.map(&([min, hour, day, month, weekday, command] = String.split(&1, " ", parts: 6)))
    |> Enum.map(&(crontime_to_schedule(&1)))
  end

  defp crontime_to_schedule(crontime) do
    case crontime do
      [min, hour, day, month, weekday, command] -> 
        case month do
         "*" -> ""
         month -> "#{month}月"
        end
        <>
        case [month, day] do
         ["*", "*"] -> ""
         ["*", day] -> "毎月#{day}日"
         [_, _] -> ""
        end
        <>
        case [day, hour] do
         ["*", "*"] -> ""
         ["*", hour] -> "毎日#{hour}時"
         [_, _] -> ""
        end
        <>
        case [min, hour, day, month, weekday] do
          [min, "*", "*", "*", "*"] -> "毎時#{min}分"
          ["*", _, _, _, _] -> ""
          [min, _, _, _, _] -> "#{min}分"
          [_, _, _, _, _] -> "非対応あるいは不正な日時"
        end
        <> "に#{command}を実行します。"
    end
  end
end
