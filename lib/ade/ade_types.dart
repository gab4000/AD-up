class ADERequestParams {
  ADERequestParams({this.address = "", this.year = "", this.location = "", this.type = "", this.referer = ""});
  String address;
  String year;
  String location;
  String type;
  String referer;
}

class ADEAuthenticatedParams extends ADERequestParams {
  ADEAuthenticatedParams({super.address, super.year, super.location, super.type, super.referer, this.credentials = ""});
  String credentials;
}

class ADESessionParams extends ADEAuthenticatedParams {
  ADESessionParams({super.address, super.year, super.location, super.type, super.referer, super.credentials, this.cookies = ""});
  String cookies;

  ADESessionParams fromADEAuthenticatedParams(ADEAuthenticatedParams params) {
    address = params.address;
    year = params.year;
    location = params.location;
    type = params.type;
    credentials = params.credentials;

    return this;
  }

  ADESessionParams updateCookies(String cookies) {
    this.cookies = cookies;
    return this;
  }
}