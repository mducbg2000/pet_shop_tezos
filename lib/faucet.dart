class Faucet {
  String mnemonic;
  String email;
  String password;

  Faucet(this.mnemonic, this.email, this.password);
}

Faucet clientFaucet() {
  List<String> listMnemonic = [
    "wing",
    "useful",
    "trim",
    "sting",
    "frost",
    "become",
    "spice",
    "come",
    "airport",
    "someone",
    "hover",
    "gain",
    "raw",
    "tone",
    "glow"
  ];
  String mnemonic = listMnemonic.join(" ");
  String email = "ewqznjct.uylqtpen@teztnets.xyz";
  String password = "5DkjW4qGMh";
  return Faucet(mnemonic, email, password);
}

Faucet masterFaucet() {
  List<String> listMnemonic = [
    "chief",
    "oven",
    "junk",
    "ranch",
    "quiz",
    "someone",
    "magic",
    "punch",
    "juice",
    "initial",
    "entire",
    "home",
    "action",
    "cruel",
    "diary"
  ];
  String mnemonic = listMnemonic.join(" ");
  String email = "cssnfdnk.nmnkkpdp@teztnets.xyz";
  String password = "25ybYEmEvY";
  return Faucet(mnemonic, email, password);
}