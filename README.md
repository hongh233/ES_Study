# 1+1 Evolution Strategy Study

This repository contains experiments and analysis focused on the 1+1 Evolution Strategy (1+1ES), specifically analyzing the impact of various parameters on the algorithm's performance.

## Extrapolate

The Extrapolate folder focuses on experiments and techniques related to extrapolation, particularly in the context of parameter tuning and optimization processes. It involves testing various methods to predict function values or parameters outside the known dataset using different models. These tests examine how the evolution of parameters like theta, alpha, and lambda affect the outcomes of the extrapolation process. The folder likely includes both 2D and higher-dimensional extrapolations, comparative studies of different rate parameters, and the development of new kernel functions for more accurate predictions. This work is key to enhancing the performance of optimization algorithms by improving their ability to estimate unseen values or trends efficiently.

## PCG

The PCG folder is focused on implementing and experimenting with the Preconditioned Conjugate Gradient (PCG) algorithm, both in its gradient and non-gradient forms. It includes variations of PCG for solving linear systems, particularly in the context of optimization, where improving computational efficiency is critical. The folder also explores techniques for calculating condition numbers and bounds related to the optimization process, providing tools for understanding the numerical stability and performance of the PCG approach in different scenarios. These implementations are designed to solve large-scale problems efficiently by utilizing preconditioning techniques to enhance convergence.

## Simplex Gradient

The Simplex Gradient folder, contains experiments and calculations involving the simplex method in the context of gradient approximation. The script evaluates the effectiveness of the simplex approach in estimating gradients for optimization tasks. It leverages simplex-based techniques to assist the 1+1ES in exploring the search space more effectively. This method helps approximate gradients when dealing with expensive function evaluations, improving convergence speed in some cases.

## Weight

The Weight folder contains various scripts that focus on analyzing and experimenting with weight functions within the context of 1+1 Evolution Strategy (1+1ES). Specifically, it includes 2D weight visualizations and experiments involving the archive of weights. The weight2D.m script utilizes Gaussian Process (GP) regression with different kernel functions and length scales to model the weight function. The experiments involve plotting the predicted values and corresponding weight functions, exploring how these change under different kernel and length scale settings.