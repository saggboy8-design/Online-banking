<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes">
    <title>Gojjam International Bank | Modern Banking Interface</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,300;14..32,400;14..32,500;14..32,600;14..32,700;14..32,800&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', system-ui, -apple-system, 'Segoe UI', Roboto, Helvetica, sans-serif;
            background: #f0f4f9;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* HERO SECTION - BANKING STYLE, COMPACT & PROFESSIONAL */
        .bank-hero {
            flex: 1;
            max-width: 1280px;
            margin: 1.5rem auto 2rem auto;
            background: linear-gradient(135deg, #ffffff 0%, #f8fafd 100%);
            border-radius: 32px;
            box-shadow: 0 20px 35px -12px rgba(0, 0, 0, 0.08), 0 1px 2px rgba(0,0,0,0.02);
            overflow: hidden;
            position: relative;
        }

        /* Decorative banking pattern */
        .bank-hero::before {
            content: "";
            position: absolute;
            top: -30%;
            right: -10%;
            width: 320px;
            height: 320px;
            background: radial-gradient(circle, rgba(245,158,11,0.08) 0%, rgba(245,158,11,0) 70%);
            border-radius: 50%;
            pointer-events: none;
        }

        .hero-container {
            padding: 2rem 2.5rem;
            position: relative;
            z-index: 1;
        }

        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: #eef2ff;
            padding: 6px 16px 6px 14px;
            border-radius: 60px;
            font-size: 0.75rem;
            font-weight: 600;
            color: #0A1F44;
            margin-bottom: 1.2rem;
            letter-spacing: 0.3px;
            border: 1px solid rgba(10,31,68,0.08);
        }
        .hero-badge i {
            font-size: 0.9rem;
            color: #f59e0b;
        }

        .hero-title {
            font-size: 2.5rem;
            font-weight: 800;
            line-height: 1.2;
            background: linear-gradient(115deg, #0A1F44 0%, #1f3b6b 100%);
            background-clip: text;
            -webkit-background-clip: text;
            color: transparent;
            margin-bottom: 0.75rem;
            letter-spacing: -0.02em;
        }

        .hero-highlight {
            display: inline-block;
            background: linear-gradient(120deg, #f59e0b20, #f59e0b08);
            padding: 0 6px;
            border-radius: 12px;
            color: #b45309;
        }

        .hero-stats {
            display: flex;
            flex-wrap: wrap;
            gap: 2rem;
            margin-top: 1.6rem;
            border-top: 1px solid #e9edf2;
            padding-top: 1.5rem;
        }

        .stat-item {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .stat-icon {
            width: 44px;
            height: 44px;
            background: #0A1F44;
            border-radius: 28px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #f59e0b;
            font-size: 1.3rem;
        }
        .stat-info h4 {
            font-size: 1.3rem;
            font-weight: 800;
            color: #0A1F44;
            line-height: 1.2;
        }
        .stat-info p {
            font-size: 0.7rem;
            font-weight: 500;
            color: #5c6f87;
            letter-spacing: 0.3px;
        }

        .hero-description {
            font-size: 1rem;
            color: #2c3e66;
            max-width: 85%;
            margin: 0.75rem 0 0 0;
            line-height: 1.5;
            font-weight: 500;
            border-left: 3px solid #f59e0b;
            padding-left: 1rem;
        }

        @media (max-width: 800px) {
            .hero-container { padding: 1.5rem; }
            .hero-title { font-size: 1.9rem; }
            .hero-description { max-width: 100%; }
            .hero-stats { gap: 1rem; justify-content: space-between; }
            .stat-icon { width: 36px; height: 36px; font-size: 1rem; }
            .stat-info h4 { font-size: 1.1rem; }
        }

        /* ========== FOOTER - REDUCED HEIGHT, MORE COMPACT ========== */
        .bank-footer {
            background: #0A1F44;
            color: rgba(255,255,255,0.8);
            margin-top: auto;
            padding: 0;
        }

        /* Compact trust strip */
        .trust-section {
            padding: 0.5rem 2rem;
            background: rgba(0,0,0,0.12);
            border-bottom: 1px solid rgba(255,255,255,0.05);
            display: flex;
            align-items: center;
            gap: 0.8rem;
            flex-wrap: wrap;
        }
        .trust-section .ts-label {
            font-size: 0.65rem;
            font-weight: 700;
            color: rgba(255,255,255,0.45);
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .trust-badge-item {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 30px;
            padding: 3px 10px;
            font-size: 0.65rem;
            font-weight: 500;
            color: rgba(255,255,255,0.75);
        }
        .trust-badge-item i { font-size: 0.7rem; color: #f59e0b; }
        .trust-badge-item.green i { color: #34d399; }

        /* Footer main grid - reduced padding and spacing */
        .footer-top {
            padding: 1rem 2rem 0.8rem 2rem;
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 1.2fr;
            gap: 1.5rem;
        }

        /* Brand horizontal layout - logo left, text right (compact) */
        .brand-horizontal {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 0.5rem;
        }
        .footer-brand img {
            height: 52px;
            width: auto;
            object-fit: contain;
            flex-shrink: 0;
            filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1));
        }
        .brand-text h3 {
            color: #fff;
            font-size: 0.85rem;
            font-weight: 800;
            margin-bottom: 0.2rem;
            letter-spacing: -0.2px;
        }
        .brand-text p {
            font-size: 0.65rem;
            line-height: 1.4;
            color: rgba(255,255,255,0.55);
            max-width: 240px;
        }

        /* Newsletter & social - more compact */
        .footer-actions {
            margin-top: 0.2rem;
        }
        .newsletter-form {
            display: flex;
            margin-top: 0.5rem;
            border-radius: 6px;
            overflow: hidden;
            border: 1px solid rgba(255,255,255,0.12);
            max-width: 250px;
        }
        .newsletter-form input {
            background: rgba(255,255,255,0.05);
            border: none;
            padding: 0.3rem 0.7rem;
            color: #fff;
            font-size: 0.7rem;
            font-family: inherit;
            outline: none;
        }
        .newsletter-form button {
            background: #f59e0b;
            border: none;
            padding: 0.3rem 0.9rem;
            color: #0A1F44;
            font-weight: 700;
            font-size: 0.65rem;
            cursor: pointer;
            transition: 0.2s;
        }
        .newsletter-form button:hover { background: #d97706; }

        .social-links {
            display: flex;
            gap: 5px;
            margin-top: 0.55rem;
        }
        .social-link {
            width: 28px;
            height: 28px;
            border-radius: 6px;
            background: rgba(255,255,255,0.06);
            border: 1px solid rgba(255,255,255,0.08);
            display: flex;
            align-items: center;
            justify-content: center;
            color: rgba(255,255,255,0.7);
            text-decoration: none;
            font-size: 0.75rem;
            transition: 0.2s;
        }
        .social-link:hover { background: #f59e0b; color: #0A1F44; }

        /* Footer columns */
        .footer-col h4 {
            color: #fff;
            font-size: 0.7rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 0.55rem;
            border-bottom: 1.5px solid #f59e0b;
            display: inline-block;
            padding-bottom: 2px;
        }
        .footer-links {
            list-style: none;
        }
        .footer-links li {
            margin-bottom: 0.25rem;
        }
        .footer-links a {
            color: rgba(255,255,255,0.6);
            text-decoration: none;
            font-size: 0.68rem;
            transition: 0.2s;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .footer-links a i {
            font-size: 0.6rem;
        }
        .footer-links a:hover { color: #f59e0b; }

        /* contact compact */
        .contact-item {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 0.45rem;
            font-size: 0.68rem;
            color: rgba(255,255,255,0.65);
        }
        .contact-item .ci-icon {
            width: 24px;
            height: 24px;
            border-radius: 6px;
            background: rgba(255,255,255,0.06);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.7rem;
            flex-shrink: 0;
            color: #f59e0b;
        }
        .contact-item strong {
            color: rgba(255,255,255,0.85);
            display: inline-block;
            margin-right: 4px;
            font-size: 0.68rem;
        }

        /* Bottom bar - minimal height */
        .footer-bottom {
            padding: 0.45rem 2rem;
            border-top: 1px solid rgba(255,255,255,0.05);
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 0.5rem;
            background: rgba(0,0,0,0.1);
        }
        .footer-bottom-copy {
            font-size: 0.6rem;
            color: rgba(255,255,255,0.4);
        }
        .footer-bottom-copy span { color: #f59e0b; font-weight: 600; }
        .footer-bottom-links {
            display: flex;
            gap: 0.8rem;
        }
        .footer-bottom-links a {
            font-size: 0.6rem;
            color: rgba(255,255,255,0.4);
            text-decoration: none;
            transition: 0.2s;
        }
        .footer-bottom-links a:hover { color: #f59e0b; }
        .footer-secure-msg {
            display: flex;
            align-items: center;
            gap: 4px;
            font-size: 0.6rem;
            color: rgba(255,255,255,0.35);
        }
        .footer-secure-msg i { color: #34d399; font-size: 0.7rem; }

        /* Responsive adjustments for compactness */
        @media (max-width: 950px) {
            .footer-top {
                grid-template-columns: 1fr 1fr;
                gap: 1rem;
            }
        }
        @media (max-width: 650px) {
            .footer-top {
                grid-template-columns: 1fr;
                padding: 0.8rem 1rem;
            }
            .brand-horizontal {
                flex-wrap: wrap;
                justify-content: center;
                text-align: center;
            }
            .brand-text p, .brand-text h3 { text-align: center; }
            .newsletter-form { margin-left: auto; margin-right: auto; }
            .social-links { justify-content: center; }
            .trust-section {
                padding: 0.4rem 1rem;
                justify-content: center;
            }
            .footer-bottom {
                flex-direction: column;
                padding: 0.6rem 1rem;
            }
        }
        @media (max-width: 480px) {
            .trust-badge-item { font-size: 0.6rem; padding: 2px 8px; }
            .footer-col h4 { font-size: 0.7rem; }
        }
    </style>
</head>
<body>

<!-- Hero Section: Banking style, authoritative & real-world bank vibe -->
<div class="bank-hero">
    <div class="hero-container">
        <div class="hero-badge">
            <i class="bi bi-bank2"></i> 
            <span>NBE Licensed · Since 1994</span>
            <i class="bi bi-patch-check-fill" style="color:#f59e0b; font-size:0.7rem;"></i>
        </div>
        <h1 class="hero-title">
            Beyond Banking, <br>
            <span class="hero-highlight">Building Futures</span>
        </h1>
        <div class="hero-description">
            <i class="bi bi-shield-lock-fill" style="color:#f59e0b; margin-right: 6px;"></i> 
            Secure, borderless & innovation-led financial services. Over 2.5M+ customers trust Gojjam International Bank with their ambitions.
        </div>
        <div class="hero-stats">
            <div class="stat-item">
                <div class="stat-icon"><i class="bi bi-people-fill"></i></div>
                <div class="stat-info"><h4>2.5M+</h4><p>Active Customers</p></div>
            </div>
            <div class="stat-item">
                <div class="stat-icon"><i class="bi bi-cash-stack"></i></div>
                <div class="stat-info"><h4>Br 48B+</h4><p>Total Assets</p></div>
            </div>
            <div class="stat-item">
                <div class="stat-icon"><i class="bi bi-building"></i></div>
                <div class="stat-info"><h4>210+</h4><p>Branches Nationwide</p></div>
            </div>
            <div class="stat-item">
                <div class="stat-icon"><i class="bi bi-star-fill"></i></div>
                <div class="stat-info"><h4>99.8%</h4><p>Digital Satisfaction</p></div>
            </div>
        </div>
    </div>
</div>

<!-- FOOTER: REDUCED HEIGHT, CLEAN & COMPACT -->
<footer class="bank-footer">
    <!-- Compact Trust & Security row -->
    <div class="trust-section">
        <span class="ts-label"><i class="bi bi-shield-check"></i> TRUST & SECURITY</span>
        <div class="trust-badge-item green"><i class="bi bi-shield-fill-check"></i> 256-bit SSL</div>
        <div class="trust-badge-item"><i class="bi bi-lock-fill"></i> Biometric Auth</div>
        <div class="trust-badge-item"><i class="bi bi-patch-check-fill"></i> NBE Regulated</div>
        <div class="trust-badge-item green"><i class="bi bi-credit-card-2-front-fill"></i> PCI DSS</div>
        <div class="trust-badge-item"><i class="bi bi-award-fill"></i> ISO 27001:2022</div>
        <div class="trust-badge-item"><i class="bi bi-cash-coin"></i> Deposit Insurance</div>
    </div>

    <div class="footer-top">
        <!-- Brand Column: Logo on left + text right (horizontal) -->
        <div class="footer-brand">
            <div class="brand-horizontal">
                <!-- Logo on left - dynamic path with fallback -->
                <img src="${pageContext.request.contextPath}/images/logo.png" 
                     alt="Gojjam International Bank" 
                     onerror="this.onerror=null; this.src='data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%20100%2040%22%3E%3Crect%20width%3D%22100%22%20height%3D%2240%22%20fill%3D%22%23f59e0b%22%2F%3E%3Ctext%20x%3D%2212%22%20y%3D%2225%22%20fill%3D%22%230A1F44%22%20font-weight%3D%22bold%22%20font-size%3D%2212%22%20font-family%3D%27Inter%27%3EGIBank%3C%2Ftext%3E%3C%2Fsvg%3E';">
                <div class="brand-text">
                    <h3>Gojjam International Bank</h3>
                    <p>Empowering Ethiopia's economy with innovative digital banking & ethical finance.</p>
                </div>
            </div>
            <div class="footer-actions">
                <div class="newsletter-form">
                    <input type="email" id="compactFooterEmail" placeholder="Email for updates">
                    <button onclick="subscribeNewsletterCompact()">Subscribe</button>
                </div>
                <div class="social-links">
                    <a href="#" class="social-link" aria-label="Facebook"><i class="bi bi-facebook"></i></a>
                    <a href="#" class="social-link" aria-label="LinkedIn"><i class="bi bi-linkedin"></i></a>
                    <a href="#" class="social-link" aria-label="Twitter"><i class="bi bi-twitter-x"></i></a>
                    <a href="#" class="social-link" aria-label="Telegram"><i class="bi bi-telegram"></i></a>
                    <a href="#" class="social-link" aria-label="YouTube"><i class="bi bi-youtube"></i></a>
                </div>
            </div>
        </div>

        <!-- Quick Links -->
        <div class="footer-col">
            <h4>Quick Links</h4>
            <ul class="footer-links">
                <li><a href="#"><i class="bi bi-chevron-right"></i> Dashboard</a></li>
                <li><a href="#"><i class="bi bi-chevron-right"></i> Online Banking</a></li>
                <li><a href="#"><i class="bi bi-chevron-right"></i> Deposit Rates</a></li>
                <li><a href="#"><i class="bi bi-chevron-right"></i> Loan Calculator</a></li>
                <li><a href="#"><i class="bi bi-chevron-right"></i> International Transfer</a></li>
                <li><a href="#"><i class="bi bi-chevron-right"></i> Bill Payment</a></li>
                <li><a href="#"><i class="bi bi-chevron-right"></i> Customer Support</a></li>
            </ul>
        </div>

        <!-- Legal & Compliance -->
        <div class="footer-col">
            <h4>Legal</h4>
            <ul class="footer-links">
                <li><a href="#"><i class="bi bi-file-earmark-text"></i> Privacy Notice</a></li>
                <li><a href="#"><i class="bi bi-file-earmark-check"></i> Terms of Service</a></li>
                <li><a href="#"><i class="bi bi-shield-check"></i> Security Center</a></li>
                <li><a href="#"><i class="bi bi-file-earmark-lock"></i> Cookie Policy</a></li>
                <li><a href="#"><i class="bi bi-currency-exchange"></i> AML Compliance</a></li>
                <li><a href="#"><i class="bi bi-question-circle"></i> FAQ & Help</a></li>
            </ul>
        </div>

        <!-- Contact Info - compact -->
        <div class="footer-col">
            <h4>Connect</h4>
            <div class="contact-item">
                <div class="ci-icon"><i class="bi bi-telephone-fill"></i></div>
                <div><strong>24/7 Helpline:</strong> +251 93 439 7418</div>
            </div>
            <div class="contact-item">
                <div class="ci-icon"><i class="bi bi-envelope-paper-fill"></i></div>
                <div><strong>Email:</strong> care@gojjambank.com.et</div>
            </div>
            <div class="contact-item">
                <div class="ci-icon"><i class="bi bi-geo-alt-fill"></i></div>
                <div><strong>HQ:</strong> Bole, Addis Ababa, Ethiopia</div>
            </div>
            <div class="contact-item">
                <div class="ci-icon"><i class="bi bi-clock-history"></i></div>
                <div><strong>Branch Hours:</strong> Mon?Fri 8:30?17:30</div>
            </div>
        </div>
    </div>

    <!-- Bottom Bar - minimal copyright & links -->
    <div class="footer-bottom">
        <div class="footer-bottom-copy">
            &copy; 2026 <span>Gojjam International Bank</span>. All rights reserved.
        </div>
        <div class="footer-bottom-links">
            <a href="#">Accessibility</a>
            <a href="#">Privacy</a>
            <a href="#">Whistleblowing</a>
            <a href="#">Sitemap</a>
        </div>
        <div class="footer-secure-msg">
            <i class="bi bi-shield-fill-check"></i> Secure Online Banking
        </div>
    </div>
</footer>

<script>
    // Newsletter subscription handler
    function subscribeNewsletterCompact() {
        const inputField = document.getElementById('compactFooterEmail');
        if (!inputField) return;
        const email = inputField.value.trim();
        const emailRegex = /^[^\s@]+@([^\s@]+\.)+[^\s@]+$/;
        if (!email || !emailRegex.test(email)) {
            alert('Please enter a valid email address to receive exclusive banking insights.');
            return;
        }
        inputField.value = '';
        alert('? You?re now subscribed! Stay tuned for Gojjam Bank financial tips and updates.');
    }

    // Demo prevention for dummy "#" links (show informative message but do not break)
    document.querySelectorAll('.social-link, .footer-bottom-links a, .footer-links a, .footer-col a[href="#"]').forEach(link => {
        if (link.getAttribute('href') === '#') {
            link.addEventListener('click', (e) => {
                e.preventDefault();
                alert('? Gojjam International Bank: This feature will be available in the full production portal.');
            });
        }
    });

    // Additional effect for any contact link or demo context
    const allDemoLinks = document.querySelectorAll('.footer-col a, .trust-badge-item, .hero-badge');
    console.log("Compact footer active | Height reduced, banking style hero ready");
</script>
</body>
</html>