module CustomTokenErrorResponse
  def body
    {
      error: ["Missing or invalid credentials."]
    }
    # or merge with existing values by
    # super.merge({key: value})
  end
end
