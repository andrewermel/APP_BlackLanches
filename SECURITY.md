# BlackLanches - Security Policy

## Reporting Security Vulnerabilities

We take security seriously. If you discover a security vulnerability, please report it responsibly:

### 📧 Contact
- **Email**: security@blacklanches.com (when available)
- **GitHub**: Create a private security advisory

### 🔒 What to Include
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Any suggested fixes

### ⏰ Response Time
- **Acknowledgment**: Within 24 hours
- **Initial Assessment**: Within 72 hours
- **Fix Timeline**: Depends on severity

## 🛡️ Security Measures Implemented

### Application Security
- ✅ **CSRF Protection**: All forms protected with Rails CSRF tokens
- ✅ **Strong Parameters**: All controller inputs sanitized
- ✅ **SQL Injection Protection**: Using Rails ORM (no raw SQL)
- ✅ **XSS Protection**: All outputs properly escaped
- ✅ **File Upload Security**: Active Storage with validation
- ✅ **Authentication**: Devise with secure defaults

### Environment Security
- ✅ **Environment Variables**: All secrets in ENV vars
- ✅ **Database Credentials**: Never hardcoded
- ✅ **SSL/TLS**: Required in production
- ✅ **Headers Security**: Security headers configured

### Code Quality
- ✅ **Static Analysis**: RuboCop compliance
- ✅ **Security Scanning**: Brakeman checks
- ✅ **Dependency Checking**: Bundler audit
- ✅ **Test Coverage**: 90%+ coverage

## 🔧 Security Configuration

### Required Environment Variables
```env
# Database
DATABASE_URL=postgresql://user:pass@host:port/db
POSTGRES_PASSWORD=secure_password

# Rails
SECRET_KEY_BASE=64_character_secret
RAILS_MASTER_KEY=32_character_key

# Optional Monitoring
SENTRY_DSN=your_sentry_dsn_here
```

### Production Recommendations
1. **Use HTTPS only** - SSL certificates required
2. **Regular Updates** - Keep dependencies updated
3. **Monitoring** - Implement error tracking (Sentry)
4. **Backups** - Regular database backups
5. **Access Control** - Limit server access

## 📋 Security Checklist

### Before Deployment
- [ ] All environment variables configured
- [ ] SSL certificate installed
- [ ] Database backups scheduled
- [ ] Error monitoring setup
- [ ] Security headers verified
- [ ] Dependency audit clean

### Regular Maintenance
- [ ] Weekly dependency updates
- [ ] Monthly security reviews
- [ ] Quarterly penetration testing
- [ ] Annual security audit

## 🚨 Known Limitations

1. **File Uploads**: Currently allows images only (3 per lanche)
2. **Rate Limiting**: Not implemented (consider for production)
3. **API**: No API endpoints (future consideration)
4. **2FA**: Not implemented (future enhancement)

## 📚 Security Resources

- [Rails Security Guide](https://guides.rubyonrails.org/security.html)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [RubySec](https://rubysec.com/)
- [Rails CVE Database](https://cve.mitre.org/)

---

**Last Updated**: January 2025  
**Next Review**: February 2025
