import pandas as pd


def load_and_clean_data(file):
    df = pd.read_csv(file, parse_dates=["Formatted Date"])

    # drop duplicates for the same date and time
    df = df.drop_duplicates(["Formatted Date"], keep="first")

    # sort data by date
    df.sort_values(by=["Formatted Date"], inplace=True)

    # reset indexes (when removing duplicates, the indexes don't change)
    df.reset_index(inplace=True, drop=True)

    # drop unnecessary columns (loud cover has 0 values, the date doesn't play a role in our predictions)
    df = df.drop(
        columns=[
            "Loud Cover",
            "Formatted Date",
            "Daily Summary",
            "Summary",
            "Precip Type",
        ]
    )

    # handle outliers
    df = df[df["Humidity"] != 0.0]
    df = df[df["Wind Speed (km/h)"] <= 60]
    df = df[df["Pressure (millibars)"] > 0]
    df.reset_index(inplace=True, drop=True)

    return df
