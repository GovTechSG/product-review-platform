module CustomTokenErrorResponse
  def body
    {
      error: "Missing or invalid credentials.",
      "status_code": "401"
    }
    # or merge with existing values by
    # super.merge({key: value})
  end
end
