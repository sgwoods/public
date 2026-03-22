(function () {
  if (!document.body || document.getElementById("archived-material-banner")) {
    return;
  }

  var style = document.createElement("style");
  style.type = "text/css";
  style.textContent =
    "#archived-material-banner{" +
    "position:fixed;" +
    "top:50%;" +
    "left:50%;" +
    "transform:translate(-50%,-50%) rotate(-28deg);" +
    "font-family:Arial,sans-serif;" +
    "font-size:clamp(36px,8vw,96px);" +
    "font-weight:700;" +
    "letter-spacing:0.18em;" +
    "text-transform:uppercase;" +
    "color:rgba(80,80,80,0.14);" +
    "pointer-events:none;" +
    "user-select:none;" +
    "white-space:nowrap;" +
    "z-index:2147483647;" +
    "text-shadow:0 1px 0 rgba(255,255,255,0.25);" +
    "}" +
    "@media print{#archived-material-banner{display:none;}}";
  document.head.appendChild(style);

  var banner = document.createElement("div");
  banner.id = "archived-material-banner";
  banner.setAttribute("aria-hidden", "true");
  banner.textContent = "Archived Material";
  document.body.appendChild(banner);
})();
