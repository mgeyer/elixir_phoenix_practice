defmodule KV.BucketTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, bucket} = KV.Bucket.start_link
    {:ok, bucket: bucket}
  end

  test "stores values by key", %{bucket: bucket} do
    # If nothing in the bucket return nil
    assert(KV.Bucket.get(bucket, "milk") == nil)

    # Once we have put something into the bucket make sure the
    # values match
    KV.Bucket.put(bucket, "eggs", 12)
    assert(KV.Bucket.get(bucket, "eggs") == 12)
  end

  test "delete by key", %{bucket: bucket} do
    assert(KV.Bucket.delete(bucket, :eggs) == nil)

    KV.Bucket.put(bucket, :eggs, 12)
    assert(KV.Bucket.delete(bucket, :eggs) == 12)
    assert(KV.Bucket.delete(bucket, :eggs) == nil)
  end
end
