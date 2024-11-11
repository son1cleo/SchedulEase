const jwt = require('jsonwebtoken');

const auth = (req, res, next) => {
    const token = req.header("x-auth-token");
    if (!token) return res.status(401).json({ message: "No authentication token, access denied" });

    try {
        const verified = jwt.verify(token, process.env.JWT_SECRET);
        req.user = verified.id;
        next();
    } catch (err) {
        res.status(401).json({ message: "Token verification failed, authorization denied" });
    }
};

module.exports = auth;
