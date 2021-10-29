# unused old experiment

{ config, pkgs, ... }:
let
  kubeMasterIP = "100.114.179.5";
  kubeMasterHostname = "api.kube";
  kubeMasterAPIServerPort = "${builtins.toString 6443}";
in
{
  # resolve master hostname
  networking.extraHosts = "${kubeMasterIP} ${kubeMasterHostname}";

  # packages for administration tasks
  environment.systemPackages = with pkgs; [
    kompose
    kubectl
    kubernetes
  ];

  services.flannel.enable = pkgs.lib.mkForce false;
  services.kubernetes = let
    api = "https://${kubeMasterHostname}:${kubeMasterAPIServerPort}";
  in
  {
    roles = ["node"];
    masterAddress = kubeMasterHostname;
    easyCerts = true;

    # point kubelet and other services to kube-apiserver
    kubelet.kubeconfig.server = api;
    apiserverAddress = api;

    # use coredns
    addons.dns.enable = true;

    # needed if you use swap
    kubelet.extraOpts = "--fail-swap-on=false";
  };
}
