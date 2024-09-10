import pandas as pd
from sklearn.model_selection import train_test_split
from data_processing import load_and_clean_data
from feature_transformation import transform_features, standardize_data
from model_evaluation import evaluate_model

df = load_and_clean_data("training data/weatherHistory.csv")

df = transform_features(df)

# split the data set (70% - train, 30% - test)
df_data = df.drop("Apparent Temperature (C)", axis=1)
df_target = pd.DataFrame(
    df["Apparent Temperature (C)"], columns=["Apparent Temperature (C)"]
)  # the column we want to predict
x_train, x_test, y_train, y_test = train_test_split(
    df_data, df_target, test_size=0.3, random_state=42
)

x_train_scaled, x_test_scaled, y_train_scaled, y_test_scaled = standardize_data(
    x_train, x_test, y_train, y_test
)

# dimension reduction using principal component analysis
from sklearn.decomposition import PCA

pca = PCA(n_components=6)
pca.fit(x_train)
pca_x_train = pca.transform(x_train)
pca_x_test = pca.transform(x_test)

# model training
from sklearn import linear_model

lm = linear_model.LinearRegression()
model = lm.fit(pca_x_train, y_train)

import joblib

joblib.dump(model, "../apparent_temp_prediction_model.pkl")
joblib.dump(pca, "../pca_transform.pkl")

evaluation = evaluate_model(model, pca_x_train, y_train, pca_x_test, y_test)

print(
    f"Train - MSE: {evaluation['train']['mse']}, RMSE: {evaluation['train']['rmse']}, Score: {evaluation['train']['score']}%"
)
print(
    f"Test - MSE: {evaluation['test']['mse']}, RMSE: {evaluation['test']['rmse']}, Score: {evaluation['test']['score']}%"
)
