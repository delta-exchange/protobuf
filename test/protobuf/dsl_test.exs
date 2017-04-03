defmodule Protobuf.DSLTest do
  use ExUnit.Case, async: true

  defmodule User_Job do
    use Protobuf
    defstruct [:name]
    field :name, 1, required: true, type: :string
  end

  defmodule User do
    use Protobuf

    defstruct [:id, :name, :addrs]

    field :id, 1, required: true, type: :int32
    field :name, 2, optional: true, type: :string
    # 3 is skipped
    field :addrs, 4, repeated: true, type: :string
    field :job, 5, optional: true, type: User_Job
  end

  test "creates __message_props__ function" do
    msg_props = User.__message_props__
    assert msg_props.tags_map == %{1 => 1, 2 => 2, 4 => 4, 5 => 5}
    field_props = msg_props.field_props
    assert %Protobuf.FieldProps{fnum: 1, name: "id", name_atom: :id,
      required: true, type: :int32, wire_type: 0} = field_props[1]
    assert %Protobuf.FieldProps{fnum: 2, name: "name", name_atom: :name,
      optional: true, type: :string, wire_type: 2} = field_props[2]
    assert %Protobuf.FieldProps{fnum: 4, name: "addrs", name_atom: :addrs,
      repeated: true, type: :string, wire_type: 2} = field_props[4]
    assert %Protobuf.FieldProps{fnum: 5, name: "job", name_atom: :job,
      optional: true, type: User_Job, wire_type: 2} = field_props[5]
  end
end
