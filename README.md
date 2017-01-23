# App-Mook

**Flawed** app for MOOC purposes

## Deploy

On a Linux/macOS box:

```bash
./bin/deps.sh
./bin/setup.sh

./bin/start.sh dev # development
./bin/start.sh     # production

./bin/status.sh
./bin/stop.sh
```

Or, via [Vagrant](https://www.vagrantup.com/) + [VirtualBox](https://www.virtualbox.org/) combo:

```bash
# up:
vagrant up

# control:
vagrant ssh -- ./app-mook/bin/status.sh
vagrant ssh -- ./app-mook/bin/stop.sh
vagrant ssh -- ./app-mook/bin/start.sh
```

Browse to [http://localhost:5000/](http://localhost:5000/). User is `jdoe`, password is `correcthorsebatterystaple`.

## Vulnerabilities

### A1 - Injection

As per [this](https://www.owasp.org/index.php/Top_10_2013-A1-Injection) page.

**Vulnerable** via (contrieved) `/not/note/:id.:format` [route](lib/App/Mook/NOT/Note.pm) which uses a route parameter without proper upfront sanitization. Fix via either SQL query parameterization technique or plain trashing of route (i.e., regular [route](lib/App/Mook/API/Note.pm) uses [DBIx::Class](https://metacpan.org/pod/DBIx::Class) ORM which properly parametrizes underlying queries for performance and security reasons).

Test [case](t/004_not_note_routes.t).

### A2 - Broken Authentication and Session Management

As per [this](https://www.owasp.org/index.php/Top_10_2013-A2-Broken_Authentication_and_Session_Management) page.

- "User authentication credentials aren’t protected when stored using hashing or encryption."

**Yep.** Hashed, albeit weakly via MD5 algorithm, but **not** salted. Fix via [Dancer2::Plugin::Passphrase](https://metacpan.org/pod/Dancer2::Plugin::Passphrase) plugin, front-end to [Crypt::Eksblowfish::Bcrypt](https://metacpan.org/pod/Crypt::Eksblowfish::Bcrypt) module. [SHA-2](https://en.wikipedia.org/wiki/Sha-2) hashes are also likely to be used via [Digest::SHA](https://metacpan.org/pod/Digest::SHA) module (via same plugin facade).

See [app-data.sql](app-data.sql) or invoke `sqlite3 app.db 'SELECT * FROM user ORDER BY id'`.

- "Credentials can be guessed or overwritten through weak account management functions (e.g., account creation, change password, recover password, weak session IDs)."

**Nope.** Session IDs to be strengthened via usage of a better PRNG back-end like [Math::Random::ISAAC](https://metacpan.org/pod/Math::Random::ISAAC) module but beware seed entropy (i.e., uses [Crypt::URandom](https://metacpan.org/pod/Crypt::URandom) module which uses [urandom](https://linux.die.net/man/4/urandom) device)! Replace some `recommends` tokens with `requires` ones in `cpanfile` file (i.e., dependencies roster) since session management factory auto-magically detects back-ends.

- "Session IDs are exposed in the URL (e.g., URL rewriting)."

**Nope, nope, nopity, nope.**

- "Session IDs are vulnerable to session fixation attacks."

**Yep.** Session cookie is not of [HttpOnly](https://www.owasp.org/index.php/HttpOnly) kind. This means cookie is likely to be exposed via injection (in turn via query parameters not sanitized in templates) of javascript code accessing `document.cookies` key. Fix via `is_secure: 1` setting in [config](config.yml) file and proper sanitization of query parameters. Usage of variables derived from query parameters (i.e., tainted data) should also be questioned in the first place.

Browse to [http://localhost:5000/](http://localhost:5000/). Should redirect to [login](http://localhost:5000/login). Log in and browse to [here](http://localhost:5000/?title=%22%3E%3Cscript%3Ealert(document.cookies)%3C/script%3E).

- "Session IDs don’t timeout, or user sessions or authentication tokens, particularly single sign-on (SSO) tokens, aren’t properly invalidated during logout."

**Yep.** Fix via `cookie_duration` key in [config](config.yml) file. Questions ubiquitous "remember me" feature BTW.

- "Session IDs aren’t rotated after successful login."

**Nope.**

- "Passwords, session IDs, and other credentials are sent over unencrypted connections."

**Yep.** Fix via usage of an HTTPS reverse proxy like [nginx](http://nginx.org/). Beware TLS certificate qualitee though. Browse to [Mozilla SSL Configuration Generator](https://mozilla.github.io/server-side-tls/ssl-config-generator/) for more.

### A3 - Cross-Site Scripting (XSS)

As per [this](https://www.owasp.org/index.php/Top_10_2013-A3-Cross-Site_Scripting_(XSS)) page.

**Yep.** See **A1** section. Fix via proper sanitization of tainted user parameters (e.g, through TT's [html](http://template-toolkit.org/docs/manual/Filters.html#section_html) filter or through [HTML::Scrubber](https://metacpan.org/pod/HTML::Scrubber) module). Also set `is_http_only: 1` in [config](config.yml) file but beware it is up to the browser to enforce `HttpOnly` kind of cookies. Also beware of payload obfuscation/encoding (i.e., assess filter).

Log in and the browse to [here](http://localhost:5000/?title="><script>alert("Pwned!")</script>). Test [case](t/006_xss.t).

### A4 - Insecure Direct Object References

As per [this](https://www.owasp.org/index.php/Top_10_2013-A4-Insecure_Direct_Object_References) page.

- "For direct references to restricted resources, does the application fail to verify the user is authorized to access the exact resource they have requested?"

**Yep.** REST routes are not authenticated. Fix via addition of ad'hoc checks in `before` hooks of controller [class](lib/App/Sec/API/Note.pm).

Browse to [logout](http://localhost:5000/logout) and then to [api/note/1.json](http://localhost:5000/api/note/1.json).

- "If the reference is an indirect reference, does the mapping to the direct reference fail to limit the values to those authorized for the current user?"

**Nope.**

### A5 - Security Misconfiguration

As per [this](https://www.owasp.org/index.php/Top_10_2013-A5-Security_Misconfiguration) page.

**FIXME**

### A6 - Sensitive Data Exposure

As per [this](https://www.owasp.org/index.php/Top_10_2013-A6-Sensitive_Data_Exposure) page.

- "Is any of this data stored in clear text long term, including backups of this data?"

**Nope.**

- "Is any of this data transmitted in clear text, internally or externally? Internet traffic is especially dangerous."

**Yep.** Albeit supposedly intranet only. Switch to an HTTPS front-end reverse proxy like [nginx](http://nginx.org/) for internet purposes.

- "Are any old / weak cryptographic algorithms used?"

**Yep.** MD5 hashes are used and, to add insult to injury, **without any salt**.

- "Are weak crypto keys generated, or is proper key management or rotation missing?"

See item above.

- "Are any browser security directives or headers missing when sensitive data is provided by / sent to the browser?"

**Yep.** Missing `HttpOnly` directive on session cookie. Also missing CSRF security cookie (see below).

### A7 - Missing Function Level Access Control

As per [this](https://www.owasp.org/index.php/Top_10_2013-A7-Missing_Function_Level_Access_Control) page.

- "Does the UI show navigation to unauthorized functions?"

**Nope.**

- "Are server side authentication or authorization checks missing?"

**Yep.** No REST route has any authentication whatsoever.

- "Are server side checks done that solely rely on information provided by the attacker?"

**Yep.** For (naïve) testing purposes.

### A8 - Cross-Site Request Forgery (CSRF)

As per [this](https://www.owasp.org/index.php/Top_10_2013-A8-Cross-Site_Request_Forgery_(CSRF)) page.

**Yep.** Fix HTML `form` nodes via [Dancer2::Plugin::CSRF](https://metacpan.org/pod/Dancer2::Plugin::CSRF) module.

### A9 - Using Components with Known Vulnerabilities

As per [this](https://www.owasp.org/index.php/Top_10_2013-A9-Using_Components_with_Known_Vulnerabilities) page.

**Most likely.** A web stack is definitely a complex assembly of (too) many components.

### A10 - Unvalidated Redirects and Forwards

**Nope.**
