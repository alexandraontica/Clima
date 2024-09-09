from sklearn.metrics import mean_squared_error
from math import sqrt


def evaluate_model(model, x_train, y_train, x_test, y_test):
    predictions_train = model.predict(x_train)
    predictions_test = model.predict(x_test)

    mse_train = mean_squared_error(y_train, predictions_train)
    mse_test = mean_squared_error(y_test, predictions_test)

    rmse_train = sqrt(mse_train)
    rmse_test = sqrt(mse_test)

    score_train = model.score(x_train, y_train) * 100
    score_test = model.score(x_test, y_test) * 100

    return {
        "train": {"mse": mse_train, "rmse": rmse_train, "score": score_train},
        "test": {"mse": mse_test, "rmse": rmse_test, "score": score_test},
    }
