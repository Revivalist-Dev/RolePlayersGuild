<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VotePrompt.ascx.cs" Inherits="RolePlayersGuild.templates.controls.VotePrompt" %>
<asp:Panel ID="pnlVotingPrompt" runat="server" CssClass="alert alert-warning clearfix" Visible="false" Style="margin: 1em 0; text-align: center;">
    <p>
        <strong>Have you voted for RPG today?</strong>
        <br />
        Don't forget to cast your vote! The higher we place, the more RPers you'll have to play with!
    </p>
    <br />
    <p>
        <a href="/VoteForRPG/" class="btn btn-success" style="width: 100%;" target="_blank">Vote Now!</a>
    </p>
</asp:Panel>
