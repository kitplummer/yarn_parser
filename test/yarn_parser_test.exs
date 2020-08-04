defmodule YarnParserTest do
  use ExUnit.Case

  test "parses comments" do
    input =
      """
      # comment
      """
    assert {:ok, parsed} = YarnParser.parse(input)
    assert parsed == %{"comments" => ["# comment"]}
  end

  test "parses properties" do
    input =
      """
      "key1" 1234
      key2 "string"
      key3 true
      key4 false
      """
    assert {:ok, parsed} = YarnParser.parse(input)
    assert parsed == %{
      "key1" => 1234,
      "key2" => "string",
      "key3" => true,
      "key4" => false
    }
  end

  test "parses blocks" do
    input =
      """
      block1:
        key1 123
      block2, block3:
        key2 321
      """

      assert {:ok, parsed} = YarnParser.parse(input)
      assert parsed == %{
        "block1" => %{"key1" => 123},
        "block2" => %{"key2" => 321},
        "block3" => %{"key2" => 321}
      }
  end

  test "parses nested blocks" do
    input =
      """
      key0 val0
      block1:
        key1 123
      block2:
        key2 321
        block2_1:
          key2_1: true
      block3:
        key3: false
      """
      assert {:ok, parsed} = YarnParser.parse(input)
      assert parsed == %{
        "block1" => %{"key1" => 123},
        "block2" => %{
          "key2" => 321,
          "block2_1" => %{
            "key2_1" => true
          }
        },
        "block3" => %{"key3" => false}
      }
  end

  test "parses sample lock" do
    input =
      """
      # THIS IS AN AUTOGENERATED FILE. DO NOT EDIT THIS FILE DIRECTLY.
      # yarn lockfile v1
      package-1@^1.0.0:
        version "1.0.3"
        resolved "https://registry.npmjs.org/package-1/-/package-1-1.0.3.tgz#a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0"
      package-2@^2.0.0:
        version "2.0.1"
        resolved "https://registry.npmjs.org/package-2/-/package-2-2.0.1.tgz#a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0"
        dependencies:
          package-4 "^4.0.0"
      package-3@^3.0.0:
        version "3.1.9"
        resolved "https://registry.npmjs.org/package-3/-/package-3-3.1.9.tgz#a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0"
        dependencies:
          package-4 "^4.5.0"
      package-4@^4.0.0, package-4@^4.5.0:
        version "4.6.3"
        resolved "https://registry.npmjs.org/package-4/-/package-4-2.6.3.tgz#a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0"
      """

    assert {:ok, parsed} = YarnParser.parse(input)
    assert parsed == %{
      "comments" => [
        "# THIS IS AN AUTOGENERATED FILE. DO NOT EDIT THIS FILE DIRECTLY.",
        "# yarn lockfile v1"
      ],
      "package-1@^1.0.0" => %{
        "version" => "1.0.3",
        "resolved" => "https://registry.npmjs.org/package-1/-/package-1-1.0.3.tgz#a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0"
      },
      "package-2@^2.0.0" => %{
        "version" => "2.0.1",
        "resolved" => "https://registry.npmjs.org/package-2/-/package-2-2.0.1.tgz#a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0",
        "dependencies" => %{
          "package-4" => "^4.0.0"
        }
      },
      "package-3@^3.0.0" => %{
        "version" => "3.1.9",
        "resolved" => "https://registry.npmjs.org/package-3/-/package-3-3.1.9.tgz#a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0",
        "dependencies" => %{
          "package-4" => "^4.5.0"
        }
      },
      "package-4@^4.0.0" => %{
        "version" => "4.6.3",
        "resolved" => "https://registry.npmjs.org/package-4/-/package-4-2.6.3.tgz#a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0",
      },
      "package-4@^4.5.0" => %{
        "version" => "4.6.3",
        "resolved" => "https://registry.npmjs.org/package-4/-/package-4-2.6.3.tgz#a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0",
      }
    }
  end
end
