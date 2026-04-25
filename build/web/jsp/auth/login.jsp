<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Gojjam International Bank ? Secure Online Banking</title>
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,500;0,600;1,300;1,400&family=DM+Sans:opsz,wght@9..40,300;9..40,400;9..40,500;9..40,600&display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"/>
  <style>
    /* ???????????????????????????????????????????
       DESIGN TOKENS
    ??????????????????????????????????????????? */
    :root {
      --navy:        #0B1F3A;
      --navy-deep:   #071629;
      --navy-mid:    #122847;
      --navy-soft:   #1A3560;
      --gold:        #C09A4F;
      --gold-light:  #D4B878;
      --gold-pale:   #EDD9A3;
      --gold-dim:    rgba(192,154,79,0.15);
      --gold-border: rgba(192,154,79,0.30);
      --cream:       #F5F0E8;
      --cream-muted: rgba(245,240,232,0.75);
      --cream-dim:   rgba(245,240,232,0.40);
      --cream-ghost: rgba(245,240,232,0.08);
      --white:       #FFFFFF;
      --success:     #27A86A;
      --danger:      #DC4C4C;
      --danger-bg:   rgba(220,76,76,0.10);
      --danger-bdr:  rgba(220,76,76,0.35);
      --text-dark:   #0B1F3A;
      --text-mid:    #2D4A6E;
      --text-muted:  #5A7A9E;
      --border:      #D8E4F0;
      --panel-bg:    #FFFFFF;
      --input-bg:    #F8FAFD;
    }

    /* ???????????????????????????????????????????
       RESET & BASE
    ??????????????????????????????????????????? */
    *, *::before, *::after {
      margin: 0; padding: 0; box-sizing: border-box;
    }
    html { height: 100%; scroll-behavior: smooth; }
    body {
      font-family: 'DM Sans', sans-serif;
      background: var(--navy-deep);
      min-height: 100%;
      display: flex;
      flex-direction: column;
      -webkit-font-smoothing: antialiased;
      -moz-osx-font-smoothing: grayscale;
    }

    /* ???????????????????????????????????????????
       GLOBAL HEADER
    ??????????????????????????????????????????? */
    .site-header {
      background: var(--navy);
      border-bottom: 1px solid var(--gold-border);
      position: sticky; top: 0; z-index: 1000;
      box-shadow: 0 2px 24px rgba(0,0,0,0.35);
    }
    .header-inner {
      max-width: 1400px; margin: 0 auto;
      padding: 0 2.5rem;
      height: 70px;
      display: flex; align-items: center; justify-content: space-between;
      gap: 1.5rem;
    }

    /* ?? Brand ?? */
    .brand {
      display: flex; align-items: center; gap: 14px;
      text-decoration: none;
    }

    /* Logo image container ? replaces the CSS "G" emblem */
    .brand-logo-wrap {
      width: 100px;
      height: 100px;
      flex-shrink: 0;
      border: 1.5px solid var(--gold-border);
      border-radius: 50%;
      background: var(--gold-dim);
      display: flex;
      align-items: center;
      justify-content: center;
      overflow: hidden;
      padding: 4px;
      position: relative;
      transition: border-color 0.22s;
    }
    .brand-logo-wrap::after {
      content: '';
      position: absolute;
      inset: 3px;
      border: 0.5px solid var(--gold-border);
      border-radius: 50%;
      pointer-events: none;
    }
    .brand-logo-wrap:hover { border-color: var(--gold); }
    .brand-logo-wrap img {
      width: 90%;
      height: 90%;
      object-fit: contain;
      border-radius: 50%;
      display: block;
    }

    .brand-copy .bank-name {
      font-family: 'Cormorant Garamond', serif;
      font-size: 1.15rem; font-weight: 500;
      color: var(--cream);
      letter-spacing: 0.02em;
      line-height: 1.2;
    }
    .brand-copy .bank-sub {
      font-size: 0.62rem; font-weight: 400;
      letter-spacing: 0.14em; text-transform: uppercase;
      color: var(--gold);
      margin-top: 2px;
    }

    /* Header utilities */
    .header-utils {
      display: flex; align-items: center; gap: 1rem;
    }
    .hdr-contact {
      display: flex; align-items: center; gap: 7px;
      border: 1px solid var(--gold-border);
      border-radius: 100px;
      padding: 6px 15px;
      font-size: 0.73rem; font-weight: 400;
      color: var(--cream-muted);
      text-decoration: none;
      transition: all 0.22s ease;
      white-space: nowrap;
    }
    .hdr-contact i { color: var(--gold); font-size: 0.85rem; }
    .hdr-contact:hover {
      background: var(--gold-dim);
      border-color: var(--gold);
      color: var(--cream);
    }
    .hdr-sep { width: 1px; height: 26px; background: var(--gold-border); }
    .hdr-secure {
      display: flex; align-items: center; gap: 7px;
      font-size: 0.65rem; font-weight: 500;
      letter-spacing: 0.1em; text-transform: uppercase;
      color: var(--gold);
    }
    .live-dot {
      width: 7px; height: 7px; border-radius: 50%;
      background: var(--success);
      box-shadow: 0 0 7px var(--success);
      animation: livePulse 2s ease-in-out infinite;
    }
    @keyframes livePulse {
      0%, 100% { opacity: 1; transform: scale(1); }
      50% { opacity: 0.45; transform: scale(0.85); }
    }

    /* ???????????????????????????????????????????
       MAIN LAYOUT
    ??????????????????????????????????????????? */
    .page-body {
      flex: 1;
      display: grid;
      grid-template-columns: 1fr 500px;
      max-width: 1400px;
      width: 100%;
      margin: 2.5rem auto;
      background: var(--panel-bg);
      border-radius: 20px;
      overflow: hidden;
      box-shadow: 0 32px 80px rgba(0,0,0,0.45), 0 0 0 1px rgba(192,154,79,0.15);
    }

    /* ???????????????????????????????????????????
       LEFT ? HERO PANEL
    ??????????????????????????????????????????? */
    .hero-panel {
      background: linear-gradient(150deg, var(--navy) 0%, var(--navy-mid) 50%, var(--navy-soft) 100%);
      padding: 3.5rem 3rem;
      display: flex; flex-direction: column;
      position: relative; overflow: hidden;
    }

    /* Architectural ring motif */
    .ring-deco {
      position: absolute;
      border: 1px solid var(--gold-border);
      border-radius: 50%;
      pointer-events: none;
    }
    .ring-deco:nth-child(1) {
      width: 520px; height: 520px;
      right: -200px; bottom: -200px;
      animation: slowSpin 80s linear infinite;
    }
    .ring-deco:nth-child(2) {
      width: 380px; height: 380px;
      right: -130px; bottom: -130px;
      animation: slowSpin 55s linear infinite reverse;
    }
    .ring-deco:nth-child(3) {
      width: 250px; height: 250px;
      right: -65px; bottom: -65px;
      animation: slowSpin 38s linear infinite;
    }
    .ring-deco:nth-child(4) {
      width: 140px; height: 140px;
      right: -10px; bottom: -10px;
      animation: slowSpin 22s linear infinite reverse;
    }
    @keyframes slowSpin { to { transform: rotate(360deg); } }

    /* Gold glow blobs */
    .glow-blob {
      position: absolute;
      border-radius: 50%;
      background: radial-gradient(circle, rgba(192,154,79,0.08), transparent 65%);
      pointer-events: none;
    }
    .glow-blob.b1 { width: 500px; height: 500px; top: -150px; left: -150px; }
    .glow-blob.b2 { width: 350px; height: 350px; bottom: -80px; right: -80px; }

    /* Hero content */
    .hero-content { position: relative; z-index: 1; flex: 1; }

    .hero-eyebrow {
      display: flex; align-items: center; gap: 12px;
      margin-bottom: 1.8rem;
    }
    .eyebrow-rule { width: 30px; height: 1px; background: var(--gold); flex-shrink: 0; }
    .eyebrow-label {
      font-size: 0.63rem; font-weight: 500;
      letter-spacing: 0.2em; text-transform: uppercase;
      color: var(--gold);
    }

    .hero-heading {
      font-family: 'Cormorant Garamond', serif;
      font-weight: 300;
      font-size: clamp(2.2rem, 3.5vw, 3.6rem);
      line-height: 1.1;
      color: var(--cream);
      margin-bottom: 1.2rem;
    }
    .hero-heading em {
      font-style: italic;
      color: var(--gold-light);
    }

    .hero-intro {
      font-size: 0.87rem; font-weight: 300;
      line-height: 1.8; color: var(--cream-muted);
      max-width: 40ch; margin-bottom: 2.5rem;
    }

    /* Metrics strip */
    .metrics {
      display: flex; gap: 2rem;
      margin-bottom: 2.5rem;
      padding-bottom: 2rem;
      border-bottom: 1px solid var(--gold-border);
    }
    .metric-val {
      font-family: 'Cormorant Garamond', serif;
      font-size: 2rem; font-weight: 400;
      color: var(--gold-light);
      line-height: 1;
      display: block;
    }
    .metric-lbl {
      font-size: 0.66rem; font-weight: 400;
      letter-spacing: 0.1em; text-transform: uppercase;
      color: var(--cream-dim);
      display: block; margin-top: 5px;
    }

    /* Feature cards */
    .features-heading {
      font-size: 0.63rem; font-weight: 500;
      letter-spacing: 0.18em; text-transform: uppercase;
      color: var(--gold); margin-bottom: 1rem;
    }
    .feature-grid {
      display: grid; grid-template-columns: 1fr 1fr;
      gap: 0.7rem; margin-bottom: 2.5rem;
    }
    .feature-card {
      display: flex; align-items: flex-start; gap: 11px;
      background: var(--cream-ghost);
      border: 1px solid rgba(192,154,79,0.12);
      border-radius: 8px;
      padding: 11px 13px;
      backdrop-filter: blur(6px);
      transition: all 0.22s ease;
      cursor: default;
    }
    .feature-card:hover {
      border-color: var(--gold-border);
      background: rgba(192,154,79,0.07);
      transform: translateY(-1px);
    }
    .fc-icon {
      width: 30px; height: 30px; flex-shrink: 0;
      border: 1px solid var(--gold-border);
      border-radius: 6px;
      display: flex; align-items: center; justify-content: center;
      color: var(--gold); font-size: 0.82rem;
      margin-top: 1px;
    }
    .fc-text {
      font-size: 0.77rem; font-weight: 400;
      color: var(--cream-muted); line-height: 1.45;
    }

    /* Compliance strip */
    .compliance-strip {
      display: flex; flex-wrap: wrap; gap: 1rem;
      padding-top: 1.5rem;
      border-top: 1px solid rgba(192,154,79,0.15);
    }
    .compliance-badge {
      display: flex; align-items: center; gap: 6px;
      font-size: 0.64rem; font-weight: 400;
      letter-spacing: 0.07em; text-transform: uppercase;
      color: var(--cream-dim);
    }
    .compliance-badge i { color: var(--gold); font-size: 0.78rem; }

    /* ???????????????????????????????????????????
       RIGHT ? LOGIN PANEL
    ??????????????????????????????????????????? */
    .login-panel {
      background: var(--panel-bg);
      padding: 3rem 2.8rem;
      display: flex; flex-direction: column; justify-content: center;
      border-left: 1px solid var(--border);
      position: relative;
    }
    .login-panel::before {
      content: '';
      position: absolute; top: 0; left: 0;
      width: 4px; height: 100%;
      background: linear-gradient(to bottom,
        transparent 0%,
        var(--gold) 20%,
        var(--gold-light) 60%,
        transparent 100%);
    }

    /* Login header */
    .login-header { margin-bottom: 2rem; }
    .login-header .kicker {
      font-size: 0.62rem; font-weight: 500;
      letter-spacing: 0.2em; text-transform: uppercase;
      color: var(--gold);
      display: flex; align-items: center; gap: 9px;
      margin-bottom: 0.7rem;
    }
    .login-header .kicker::before {
      content: ''; display: block;
      width: 18px; height: 1px; background: var(--gold);
    }
    .login-header h2 {
      font-family: 'Cormorant Garamond', serif;
      font-size: 2rem; font-weight: 500;
      color: var(--text-dark); line-height: 1.15;
      margin-bottom: 0.55rem;
    }
    .login-header .subtitle {
      font-size: 0.82rem; font-weight: 400;
      color: var(--text-muted); line-height: 1.6;
    }

    /* Login panel logo ? larger logo shown above the sign-in form */
    .login-logo-wrap {
      display: flex;
      justify-content: center;
      margin-bottom: 1.6rem;
    }
    .login-logo-wrap img {
      width: 170px;
      height: 170px;
      object-fit: contain;
      border-radius: 50%;
      border: 2px solid var(--gold-border);
      padding: 6px;
      background: var(--input-bg);
      box-shadow: 0 4px 20px rgba(192,154,79,0.15);
      transition: box-shadow 0.3s, border-color 0.3s;
    }
    .login-logo-wrap img:hover {
      border-color: var(--gold);
      box-shadow: 0 6px 28px rgba(192,154,79,0.28);
    }

    /* Info callout */
    .info-callout {
      display: flex; gap: 11px; align-items: flex-start;
      background: #EBF4FF;
      border: 1px solid #B8D4F0;
      border-radius: 8px;
      padding: 11px 14px;
      margin-bottom: 1.6rem;
      font-size: 0.79rem; font-weight: 400;
      color: var(--text-mid); line-height: 1.5;
    }
    .info-callout i { color: #1A6CB7; font-size: 1rem; margin-top: 1px; flex-shrink: 0; }

    /* Error alert */
    .alert-error {
      display: flex; gap: 10px; align-items: flex-start;
      background: var(--danger-bg);
      border: 1px solid var(--danger-bdr);
      border-radius: 8px;
      padding: 11px 14px;
      margin-bottom: 1.4rem;
      font-size: 0.8rem; font-weight: 400;
      color: #7A1C1C; line-height: 1.5;
    }
    .alert-error i { color: var(--danger); font-size: 1rem; margin-top: 1px; flex-shrink: 0; }

    /* Form groups */
    .form-section-label {
      font-size: 0.62rem; font-weight: 500;
      letter-spacing: 0.14em; text-transform: uppercase;
      color: var(--text-muted);
      margin-bottom: 1rem;
      display: flex; align-items: center; gap: 8px;
    }
    .form-section-label::after {
      content: ''; flex: 1; height: 1px; background: var(--border);
    }

    .input-group { margin-bottom: 1.15rem; }
    .input-label {
      display: block;
      font-size: 0.72rem; font-weight: 600;
      letter-spacing: 0.06em; text-transform: uppercase;
      color: var(--text-dark);
      margin-bottom: 6px;
    }
    .input-field-wrapper {
      position: relative;
    }
    .input-icon {
      position: absolute; left: 13px; top: 50%;
      transform: translateY(-50%);
      color: var(--text-muted); font-size: 0.9rem;
      pointer-events: none;
    }
    .form-control {
      width: 100%;
      padding: 0.72rem 2.6rem 0.72rem 2.6rem;
      background: var(--input-bg);
      border: 1.5px solid var(--border);
      border-radius: 8px;
      font-family: 'DM Sans', sans-serif;
      font-size: 0.88rem; font-weight: 400;
      color: var(--text-dark);
      outline: none;
      transition: border-color 0.22s ease, box-shadow 0.22s ease, background 0.22s ease;
      caret-color: var(--gold);
    }
    .form-control::placeholder { color: var(--text-muted); opacity: 0.6; }
    .form-control:focus {
      border-color: var(--navy-soft);
      background: var(--white);
      box-shadow: 0 0 0 3px rgba(26,53,96,0.10);
    }
    .form-control:hover:not(:focus) { border-color: var(--text-muted); }
    .form-control.is-invalid { border-color: var(--danger); box-shadow: 0 0 0 3px var(--danger-bg); }
    .form-control.is-valid   { border-color: var(--success); }

    .toggle-password {
      position: absolute; right: 12px; top: 50%;
      transform: translateY(-50%);
      background: none; border: none; cursor: pointer;
      color: var(--text-muted); font-size: 0.9rem;
      padding: 3px; transition: color 0.2s;
    }
    .toggle-password:hover { color: var(--navy); }

    .input-hint {
      display: none; font-size: 0.71rem; margin-top: 5px; padding-left: 2px;
    }
    .input-hint.error { color: var(--danger); display: block; }
    .input-hint.info  { color: var(--text-muted); display: block; }
    .input-hint.ok    { color: var(--success); display: block; }

    /* Checkbox row */
    .checkbox-row {
      display: flex; align-items: center; gap: 9px;
      margin-bottom: 1.4rem;
    }
    .checkbox-row input[type="checkbox"] {
      width: 15px; height: 15px;
      accent-color: var(--navy); cursor: pointer;
    }
    .checkbox-row label {
      font-size: 0.79rem; font-weight: 400;
      color: var(--text-muted); cursor: pointer;
      line-height: 1.4;
    }

    /* Submit button */
    .btn-submit {
      width: 100%;
      padding: 0.82rem 1rem;
      background: var(--navy);
      color: var(--white);
      border: none; border-radius: 8px;
      font-family: 'DM Sans', sans-serif;
      font-size: 0.9rem; font-weight: 600;
      letter-spacing: 0.03em;
      cursor: pointer;
      display: flex; align-items: center; justify-content: center; gap: 8px;
      transition: background 0.22s ease, transform 0.15s ease, box-shadow 0.22s ease;
      margin-bottom: 0.75rem;
    }
    .btn-submit:hover {
      background: var(--navy-soft);
      transform: translateY(-1px);
      box-shadow: 0 10px 28px rgba(11,31,58,0.30);
    }
    .btn-submit:active { transform: translateY(0); }
    .btn-submit:disabled { opacity: 0.55; cursor: not-allowed; transform: none; }

    .btn-gold-accent {
      width: 100%;
      padding: 0.68rem 1rem;
      background: transparent;
      color: var(--navy);
      border: 1.5px solid var(--gold);
      border-radius: 8px;
      font-family: 'DM Sans', sans-serif;
      font-size: 0.84rem; font-weight: 500;
      cursor: pointer;
      display: flex; align-items: center; justify-content: center; gap: 8px;
      text-decoration: none;
      transition: background 0.22s, color 0.22s;
    }
    .btn-gold-accent:hover {
      background: var(--gold);
      color: var(--white);
    }

    /* Loading spinner */
    .btn-spinner {
      display: none;
      width: 17px; height: 17px;
      border: 2px solid rgba(255,255,255,0.35);
      border-top-color: #fff;
      border-radius: 50%;
      animation: spin 0.7s linear infinite;
    }
    @keyframes spin { to { transform: rotate(360deg); } }

    /* Divider */
    .or-divider {
      display: flex; align-items: center; gap: 12px;
      margin: 1.4rem 0;
      font-size: 0.7rem; font-weight: 500;
      letter-spacing: 0.12em; text-transform: uppercase;
      color: var(--text-muted);
    }
    .or-divider::before, .or-divider::after {
      content: ''; flex: 1; height: 1px; background: var(--border);
    }

    /* Register CTA */
    .register-cta {
      background: var(--input-bg);
      border: 1px solid var(--border);
      border-radius: 10px;
      padding: 1.1rem 1.3rem;
      text-align: center; margin-bottom: 1.5rem;
    }
    .register-cta p {
      font-size: 0.8rem; color: var(--text-muted);
      line-height: 1.5; margin-bottom: 0.8rem;
    }
    .register-cta p strong { color: var(--text-dark); font-weight: 600; }
    .register-cta a {
      display: inline-flex; align-items: center; gap: 7px;
      background: var(--navy);
      color: var(--white);
      border-radius: 100px;
      padding: 0.5rem 1.4rem;
      font-size: 0.78rem; font-weight: 600;
      text-decoration: none;
      transition: background 0.22s;
    }
    .register-cta a:hover { background: var(--navy-soft); }

    /* Security footer */
    .sec-footer {
      display: flex; flex-direction: column; gap: 6px;
    }
    .sec-row {
      display: flex; align-items: center; justify-content: center;
      gap: 8px; flex-wrap: wrap;
    }
    .sec-badge {
      display: flex; align-items: center; gap: 5px;
      font-size: 0.67rem; color: var(--text-muted);
    }
    .sec-badge i { color: var(--navy-soft); font-size: 0.78rem; }
    .sec-sep { color: var(--border); }
    .sec-warning {
      font-size: 0.67rem; color: var(--text-muted);
      text-align: center; line-height: 1.5;
    }

    /* ???????????????????????????????????????????
       FOOTER
    ??????????????????????????????????????????? */
    .site-footer {
      background: var(--navy-deep);
      border-top: 1px solid var(--gold-border);
    }
    .footer-inner {
      max-width: 1400px; margin: 0 auto;
      padding: 2.5rem 2.5rem 1.2rem;
    }
    .footer-grid {
      display: grid;
      grid-template-columns: 1.8fr 1fr 1fr 1fr;
      gap: 2.5rem;
      margin-bottom: 2rem;
    }
    .footer-col-heading {
      font-size: 0.62rem; font-weight: 600;
      letter-spacing: 0.16em; text-transform: uppercase;
      color: var(--gold);
      margin-bottom: 1.1rem;
      display: flex; align-items: center; gap: 8px;
    }
    .footer-col-heading::before {
      content: ''; display: block;
      width: 12px; height: 1px; background: var(--gold);
    }
    .footer-col p, .footer-col address {
      font-size: 0.74rem; font-style: normal;
      color: var(--cream-dim); line-height: 1.95;
    }
    .footer-col a {
      display: block; font-size: 0.74rem;
      color: var(--cream-dim); text-decoration: none;
      line-height: 2; transition: color 0.2s;
    }
    .footer-col a:hover { color: var(--gold-light); }
    .footer-disclaimer {
      font-size: 0.68rem; color: rgba(245,240,232,0.25);
      line-height: 1.7; margin-top: 0.8rem; max-width: 48ch;
    }
    .social-links {
      display: flex; gap: 8px; margin-top: 1rem;
    }
    .social-btn {
      width: 32px; height: 32px;
      border: 1px solid var(--gold-border);
      border-radius: 6px;
      display: flex; align-items: center; justify-content: center;
      color: var(--cream-dim); font-size: 0.88rem;
      text-decoration: none;
      transition: all 0.22s;
    }
    .social-btn:hover {
      background: var(--gold);
      color: var(--navy-deep);
      border-color: var(--gold);
      transform: translateY(-2px);
    }
    .footer-bottom {
      border-top: 1px solid rgba(192,154,79,0.12);
      padding-top: 1.2rem;
      display: flex; justify-content: space-between;
      align-items: center; flex-wrap: wrap; gap: 0.75rem;
    }
    .footer-copy { font-size: 0.68rem; color: rgba(245,240,232,0.25); }
    .footer-links { display: flex; gap: 1.5rem; }
    .footer-links a {
      font-size: 0.68rem; color: rgba(245,240,232,0.25);
      text-decoration: none; transition: color 0.2s;
    }
    .footer-links a:hover { color: var(--gold); }

    /* ???????????????????????????????????????????
       ENTRY ANIMATIONS
    ??????????????????????????????????????????? */
    @keyframes fadeSlideUp {
      from { opacity: 0; transform: translateY(18px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    .anim { animation: fadeSlideUp 0.65s cubic-bezier(0.22, 1, 0.36, 1) both; }
    .d1 { animation-delay: 0.08s; }
    .d2 { animation-delay: 0.18s; }
    .d3 { animation-delay: 0.28s; }
    .d4 { animation-delay: 0.38s; }
    .d5 { animation-delay: 0.48s; }
    .d6 { animation-delay: 0.58s; }
    .d7 { animation-delay: 0.68s; }

    /* ???????????????????????????????????????????
       RESPONSIVE
    ??????????????????????????????????????????? */
    @media (max-width: 1100px) {
      .page-body { grid-template-columns: 1fr; margin: 1rem; }
      .login-panel { border-left: none; border-top: 1px solid var(--border); }
      .hero-panel { min-height: 50vh; }
    }
    @media (max-width: 760px) {
      .header-inner { padding: 0 1.5rem; }
      .hdr-contact:nth-child(3) { display: none; }
      .hero-panel { padding: 2.5rem 2rem; }
      .feature-grid { grid-template-columns: 1fr; }
      .login-panel { padding: 2.2rem 1.8rem; }
      .footer-grid { grid-template-columns: 1fr 1fr; }
      .metrics { gap: 1.3rem; }
    }
    @media (max-width: 500px) {
      .feature-grid { grid-template-columns: 1fr; }
      .footer-grid { grid-template-columns: 1fr; }
      .hdr-secure { display: none; }
      .hdr-sep { display: none; }
    }
  </style>
</head>
<body>

<!-- ???????????????????????????????????????????
     GLOBAL HEADER
??????????????????????????????????????????? -->
<header class="site-header">
  <div class="header-inner">

    <a href="#" class="brand">
      <%-- Logo image ? replaces the CSS "G" emblem --%>
      <div class="brand-logo-wrap">
        <img
          src="${pageContext.request.contextPath}/images/logo.png"
          alt="Gojjam International Bank Logo"
        />
      </div>
      <div class="brand-copy">
        <div class="bank-name">Gojjam International Bank</div>
        <div class="bank-sub">Est. 1994 &nbsp;�&nbsp; NBE Licensed &nbsp;�&nbsp; Member EDIC</div>
      </div>
    </a>

    <div class="header-utils">
      <a href="tel:+251934397418" class="hdr-contact">
        <i class="bi bi-telephone-fill"></i>
        24/7 Support: +251 93 439 7418
      </a>
      <div class="hdr-sep"></div>
      <a href="mailto:leamilak11@gmail.com" class="hdr-contact">
        <i class="bi bi-envelope-fill"></i>
        support@gojjambank.com.et
      </a>
      <div class="hdr-sep"></div>
      <div class="hdr-secure">
        <div class="live-dot"></div>
        Secured Connection
      </div>
    </div>

  </div>
</header>

<!-- ???????????????????????????????????????????
     MAIN ? SPLIT LAYOUT
??????????????????????????????????????????? -->
<div class="page-body">

  <!-- ? LEFT: HERO PANEL ? -->
  <section class="hero-panel">
    <div class="ring-deco"></div>
    <div class="ring-deco"></div>
    <div class="ring-deco"></div>
    <div class="ring-deco"></div>
    <div class="glow-blob b1"></div>
    <div class="glow-blob b2"></div>

    <div class="hero-content">

      <div class="hero-eyebrow anim d1">
        <div class="eyebrow-rule"></div>
        <span class="eyebrow-label">Ethiopia's Premier Private Institution</span>
      </div>

      <h1 class="hero-heading anim d2">
        Banking Built<br/>on <em>Trust</em>,<br/>Designed for<br/><em>Growth</em>
      </h1>

      <p class="hero-intro anim d3">
        For over thirty years, Gojjam International Bank has been the financial backbone of Ethiopia's most ambitious individuals, families, and enterprises ? offering the precision, discretion, and institutional strength of a true private bank.
      </p>

      <div class="metrics anim d3">
        <div>
          <span class="metric-val">30+</span>
          <span class="metric-lbl">Years of Service</span>
        </div>
        <div>
          <span class="metric-val">?120B</span>
          <span class="metric-lbl">Assets Managed</span>
        </div>
        <div>
          <span class="metric-val">9.5%</span>
          <span class="metric-lbl">Max Savings Rate p.a.</span>
        </div>
      </div>

      <div class="features-heading anim d4">Why Clients Choose Us</div>

      <div class="feature-grid anim d4">
        <div class="feature-card">
          <div class="fc-icon"><i class="bi bi-shield-lock-fill"></i></div>
          <span class="fc-text">256-bit TLS 1.3 encryption on every transaction, round-the-clock</span>
        </div>
        <div class="feature-card">
          <div class="fc-icon"><i class="bi bi-lightning-charge-fill"></i></div>
          <span class="fc-text">Instant real-time transfers to any Ethiopian bank via RTGS &amp; SWIFT</span>
        </div>
        <div class="feature-card">
          <div class="fc-icon"><i class="bi bi-phone-fill"></i></div>
          <span class="fc-text">Full-featured web, iOS &amp; Android banking ? access from anywhere</span>
        </div>
        <div class="feature-card">
          <div class="fc-icon"><i class="bi bi-award-fill"></i></div>
          <span class="fc-text">Fully licensed &amp; supervised by the National Bank of Ethiopia</span>
        </div>
        <div class="feature-card">
          <div class="fc-icon"><i class="bi bi-graph-up-arrow"></i></div>
          <span class="fc-text">Earn up to 9.5% p.a. on fixed deposits ? among Ethiopia's highest</span>
        </div>
        <div class="feature-card">
          <div class="fc-icon"><i class="bi bi-credit-card-2-back-fill"></i></div>
          <span class="fc-text">International Visa &amp; Mastercard debit cards with contactless pay</span>
        </div>
      </div>

      <div class="compliance-strip anim d5">
        <div class="compliance-badge"><i class="bi bi-lock-fill"></i> TLS 1.3 Secured</div>
        <div class="compliance-badge"><i class="bi bi-patch-check-fill"></i> NBE Regulated</div>
        <div class="compliance-badge"><i class="bi bi-shield-fill-check"></i> Fraud Monitoring 24/7</div>
        <div class="compliance-badge"><i class="bi bi-bank2"></i> EDIC Insured up to 100k ETB</div>
        <div class="compliance-badge"><i class="bi bi-eye-slash-fill"></i> AML/KYC Compliant</div>
      </div>

    </div>
  </section>

  <!-- ? RIGHT: LOGIN PANEL ? -->
  <aside class="login-panel">

    <%-- Prominent logo above the sign-in form --%>
    <div class="login-logo-wrap anim d1">
      <img
        src="${pageContext.request.contextPath}/images/logo.png"
        alt="Gojjam International Bank"
      />
    </div>

    <div class="login-header anim d1">
      <div class="kicker">Private Banking Portal</div>
      <h2>Secure Sign In</h2>
      <p class="subtitle">
        Access your personal or corporate banking dashboard. All sessions are encrypted and monitored for your protection.
      </p>
    </div>

    <!-- Informational callout -->
    <div class="info-callout anim d2">
      <i class="bi bi-info-circle-fill"></i>
      <div>
        <strong>Reminder:</strong> Gojjam Bank will <strong>never</strong> ask for your full password, OTP, or PIN over phone or email. Always verify you are on <em>gojjambank.com.et</em> before logging in.
      </div>
    </div>

    <%-- Server-side error (uncomment for JSP):
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert-error anim d2">
      <i class="bi bi-exclamation-triangle-fill"></i>
      <div>
        <strong>Sign-in failed.</strong> The username or password you entered is incorrect.
        Please try again or <a href="${pageContext.request.contextPath}/forgot-password">reset your password</a>.
      </div>
    </div>
    <% } %>
    --%>

    <form id="loginForm" method="post" action="${pageContext.request.contextPath}/login" novalidate>
      <input type="hidden" name="csrfToken" value="${csrfToken}"/>

      <div class="form-section-label anim d2">Account Credentials</div>

      <!-- ?? Username ?? -->
      <div class="input-group anim d3">
        <label class="input-label" for="usernameInput">Username or Email Address</label>
        <div class="input-field-wrapper">
          <i class="bi bi-person input-icon"></i>
          <input
            type="text"
            id="usernameInput"
            name="username"
            class="form-control"
            placeholder="username or you@example.com"
            autocomplete="username"
            required
          />
        </div>
        <div class="input-hint" id="userHint"></div>
      </div>

      <!-- ?? Password ?? -->
      <div class="input-group anim d3">
        <div style="display:flex; justify-content:space-between; align-items:center;">
          <label class="input-label" for="pwdInput" style="margin-bottom:0;">Password</label>
          <a
            href="${pageContext.request.contextPath}/forgot-password"
            style="font-size:0.72rem; color:var(--navy-soft); font-weight:600; text-decoration:none; transition:color 0.2s;"
            onmouseover="this.style.color='var(--gold)'"
            onmouseout="this.style.color='var(--navy-soft)'"
          >Forgot password?</a>
        </div>
        <div class="input-field-wrapper" style="margin-top:6px;">
          <i class="bi bi-lock input-icon"></i>
          <input
            type="password"
            id="pwdInput"
            name="password"
            class="form-control"
            placeholder="Enter your secure password"
            autocomplete="current-password"
            required
          />
          <button
            type="button"
            class="toggle-password"
            onclick="togglePasswordVisibility()"
            aria-label="Toggle password visibility"
          >
            <i id="eyeIcon" class="bi bi-eye"></i>
          </button>
        </div>
        <div class="input-hint" id="pwdHint"></div>
      </div>

      <!-- ?? Remember Me ?? -->
      <div class="checkbox-row anim d4">
        <input type="checkbox" id="rememberMe" name="remember"/>
        <label for="rememberMe">Remember me</label>
      </div>

      <!-- ?? Primary CTA ?? -->
      <button type="submit" class="btn-submit anim d4" id="loginBtn">
        <span id="btnLabel">
          <i class="bi bi-box-arrow-in-right"></i> Access My Account
        </span>
        <span class="btn-spinner" id="btnSpinner"></span>
      </button>

    </form>

    <div class="or-divider anim d5">new to gojjam bank?</div>

    <div class="register-cta anim d5">
      <p>
        <strong>Open an account today</strong> and join over 500,000 Ethiopians who trust Gojjam International Bank with their financial future.
      </p>
      <a href="${pageContext.request.contextPath}/register">
        <i class="bi bi-person-plus-fill"></i> Open Account
      </a>
    </div>

    <div class="sec-footer anim d6">
      <div class="sec-row">
        <div class="sec-badge"><i class="bi bi-shield-lock-fill"></i> 256-bit SSL</div>
        <span class="sec-sep">|</span>
        <div class="sec-badge"><i class="bi bi-clock-history"></i> Session: 15 min</div>
        <span class="sec-sep">|</span>
        <div class="sec-badge"><i class="bi bi-eye-slash-fill"></i> Private &amp; Encrypted</div>
      </div>
      <p class="sec-warning">
        This system is restricted to authorized users only. Unauthorized access attempts are logged, monitored, and prosecuted under Ethiopian cybercrime law.
      </p>
    </div>

  </aside>
</div>

<!-- ???????????????????????????????????????????
     SITE FOOTER
??????????????????????????????????????????? -->
<footer class="site-footer">
  <div class="footer-inner">
    <div class="footer-grid">

      <div class="footer-col">
        <div class="footer-col-heading">Gojjam International Bank</div>
        <address>
          Head Office: Bole Road, Addis Ababa<br/>
          Federal Democratic Republic of Ethiopia<br/>
          SWIFT: GOJIETAA &nbsp;�&nbsp; IBAN: ET00 GOJI XXXX<br/>
          P.O. Box 12345 &nbsp;�&nbsp; Tel: +251 93 439 7418
        </address>
        <p class="footer-disclaimer">
          Gojjam International Bank S.C. is licensed and regulated by the National Bank of Ethiopia (NBE). Deposits are insured up to ETB 100,000 through the Ethiopian Deposit Insurance Corporation (EDIC).
        </p>
        <div class="social-links">
          <a href="#" class="social-btn"><i class="bi bi-facebook"></i></a>
          <a href="#" class="social-btn"><i class="bi bi-linkedin"></i></a>
          <a href="#" class="social-btn"><i class="bi bi-twitter-x"></i></a>
          <a href="#" class="social-btn"><i class="bi bi-instagram"></i></a>
          <a href="#" class="social-btn"><i class="bi bi-telegram"></i></a>
          <a href="#" class="social-btn"><i class="bi bi-youtube"></i></a>
        </div>
      </div>

      <div class="footer-col">
        <div class="footer-col-heading">Institution</div>
        <a href="#">About Gojjam Bank</a>
        <a href="#">Board of Directors</a>
        <a href="#">Executive Management</a>
        <a href="#">Annual Reports &amp; Financials</a>
        <a href="#">Careers &amp; Opportunities</a>
        <a href="#">Press &amp; Media</a>
        <a href="#">Investor Relations</a>
        <a href="#">CSR &amp; Community</a>
      </div>

      <div class="footer-col">
        <div class="footer-col-heading">Customer Services</div>
        <a href="#">Branch &amp; ATM Locator</a>
        <a href="#">Live Exchange Rates</a>
        <a href="#">Interest Rate Schedule</a>
        <a href="#">Loan Eligibility Calculator</a>
        <a href="#">Schedule an Appointment</a>
        <a href="#">24/7 Customer Care</a>
        <a href="#">Complaint Resolution</a>
        <a href="#">Fraud &amp; Security Alerts</a>
      </div>

      <div class="footer-col">
        <div class="footer-col-heading">Legal &amp; Compliance</div>
        <a href="#">Privacy Policy</a>
        <a href="#">Terms &amp; Conditions</a>
        <a href="#">Cookie Policy</a>
        <a href="#">AML / KYC Disclosure</a>
        <a href="#">Regulatory Filings</a>
        <a href="#">Whistleblowing Portal</a>
        <a href="#">Accessibility Statement</a>
        <a href="#">Fraud Awareness Guide</a>
      </div>

    </div>

    <div class="footer-bottom">
      <div class="footer-copy">
        &copy; 2026 Gojjam International Bank S.C. All rights reserved. &nbsp;�&nbsp; NBE Reg. No. 1994/01 &nbsp;�&nbsp; Addis Ababa, Ethiopia
      </div>
      <div class="footer-links">
        <a href="#">Sitemap</a>
        <a href="#">Accessibility</a>
        <a href="#">Cookie Preferences</a>
        <a href="#">Fraud Awareness</a>
      </div>
    </div>
  </div>
</footer>

<!-- ???????????????????????????????????????????
     JAVASCRIPT
??????????????????????????????????????????? -->
<script>
  /* ?? Toggle password visibility ?? */
  function togglePasswordVisibility() {
    const input = document.getElementById('pwdInput');
    const icon  = document.getElementById('eyeIcon');
    const isHidden = input.type === 'password';
    input.type     = isHidden ? 'text' : 'password';
    icon.className = isHidden ? 'bi bi-eye-slash' : 'bi bi-eye';
  }

  /* ?? Live username validation ?? */
  document.getElementById('usernameInput').addEventListener('blur', function () {
    const hint = document.getElementById('userHint');
    const val  = this.value.trim();
    if (!val) {
      setFieldState(this, hint, 'error', '? Please enter your username or email address.');
    } else if (val.includes('@') && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val)) {
      setFieldState(this, hint, 'error', '? That email address appears to be invalid.');
    } else {
      setFieldState(this, hint, 'ok', '');
      hint.style.display = 'none';
    }
  });

  /* ?? Live password validation ?? */
  document.getElementById('pwdInput').addEventListener('input', function () {
    const hint = document.getElementById('pwdHint');
    const len  = this.value.length;
    if (len === 0) {
      this.classList.remove('is-invalid', 'is-valid');
      hint.className = 'input-hint';
    } else if (len < 8) {
      setFieldState(this, hint, 'error', '? Password must be at least 8 characters.');
    } else {
      setFieldState(this, hint, 'ok', '');
      hint.style.display = 'none';
    }
  });

  /* ?? Form submission ?? */
  document.getElementById('loginForm').addEventListener('submit', function (e) {
    const uInput = document.getElementById('usernameInput');
    const pInput = document.getElementById('pwdInput');
    const uHint  = document.getElementById('userHint');
    const pHint  = document.getElementById('pwdHint');
    let valid    = true;

    if (!uInput.value.trim()) {
      setFieldState(uInput, uHint, 'error', '? Username or email is required.');
      valid = false;
    }
    if (!pInput.value) {
      setFieldState(pInput, pHint, 'error', '? Password is required.');
      valid = false;
    } else if (pInput.value.length < 8) {
      setFieldState(pInput, pHint, 'error', '? Password must be at least 8 characters.');
      valid = false;
    }

    if (!valid) { e.preventDefault(); return; }

    /* Show loading state */
    const btn     = document.getElementById('loginBtn');
    const label   = document.getElementById('btnLabel');
    const spinner = document.getElementById('btnSpinner');
    btn.disabled          = true;
    label.style.display   = 'none';
    spinner.style.display = 'inline-block';
  });

  /* ?? Helper: set field validation state ?? */
  function setFieldState(input, hintEl, state, message) {
    input.classList.remove('is-invalid', 'is-valid');
    hintEl.className = 'input-hint';
    if (state === 'error') {
      input.classList.add('is-invalid');
      hintEl.classList.add('error');
      hintEl.textContent = message;
    } else if (state === 'ok') {
      input.classList.add('is-valid');
    }
  }

  /* ?? Prevent footer hash links from jumping ?? */
  document.querySelectorAll('a[href="#"]').forEach(a => {
    a.addEventListener('click', e => e.preventDefault());
  });
</script>
</body>
</html>
