const express = require('express');
const puppeteer = require('puppeteer');
const app = express();
app.use(express.json());

app.post('/scan', async (req, res) => {
    const { email, password, proxy } = req.body; // proxy dạng host:port:user:pass

    const browser = await puppeteer.launch({
        args: [
            '--no-sandbox',
            '--disable-setuid-sandbox',
            proxy ? `--proxy-server=http://${proxy.split(':')[0]}:${proxy.split(':')[1]}` : ''
        ].filter(Boolean)
    });

    try {
        const page = await browser.newPage();
        
        // Nếu có proxy user/pass
        if (proxy && proxy.split(':').length === 4) {
            await page.authenticate({
                username: proxy.split(':')[2],
                password: proxy.split(':')[3]
            });
        }

        await page.goto('https://www.netflix.com/login', { waitUntil: 'networkidle2' });
        await page.type('input[name="userLoginId"]', email);
        await page.type('input[name="password"]', password);
        
        await Promise.all([
            page.click('button[type="submit"]'),
            page.waitForNavigation({ waitUntil: 'networkidle2', timeout: 30000 }),
        ]);

        if (page.url().includes('/browse')) {
            const cookies = await page.cookies();
            res.json({ status: 'success', cookies });
        } else {
            res.status(401).json({ status: 'fail', message: 'Login failed' });
        }
    } catch (err) {
        res.status(500).json({ error: err.message });
    } finally {
        await browser.close();
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server is running on port ${PORT}`));
