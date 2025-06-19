<%@ Page Title="RPG: Error Page" Language="C#" MasterPageFile="~/templates/1-Col.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.Error.BadRequest.Default" %>

<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="As a site that is constantly under development and growth, errors are often an unfortunate expectation." />
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="FullCol" runat="server">
    <h1>Error</h1>

    <div class="alert alert-danger">
        <asp:Literal ID="litErrorMessage" runat="server"></asp:Literal>
    </div>

    <div runat="server" id="divMarketing" class="jumbotron" visible="false"><h2>While you're here, though...</h2>
        <p>Have you considered creating an account on the Role-Players Guild? If you haven't already and you like to Role-Play, you really should! RPG is built from the ground up for RPers. This isn't some boxed social media tool or forum tool that's repurposed to fit our needs, it's a fully customized, fully functional interface built solely via the feedback of our users and the experience of our developers.</p>
        <p><a href="/Register/?src=ErrorPage&type=<%= Request.QueryString["type"] %>" class="btn btn-primary btn-lg">Join RPG Today!</a></p>        
    </div>
</asp:Content>
