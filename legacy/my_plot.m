function my_plot(RMSE_TIME,name)
    figure();
    plot(RMSE_TIME(:, 1), RMSE_TIME(:, 2));
    xlabel("Time");
    ylabel("RMSE");
    saveas(gcf,name,'epsc');
end

