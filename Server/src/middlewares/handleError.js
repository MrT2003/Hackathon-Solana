import createHttpError from 'http-errors';

export function handleError(app) {
    app.use(async (req, res, next) => {
        next(createHttpError.NotFound("This route does not exist! Please try another route."));
    });

    app.use((err, req, res, next) => {
        res.status(err.status || 500);
        res.send({
            error: {
                status: err.status || 500,
                message: err.message,
            },
        });
    });
}
